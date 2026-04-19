#CREATING THE VPC
resource "aws_vpc" "Task_2_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Task-2-dev-vpc"
  }
}



# CREATING THE IGW AND ATTACHED TO THE VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.Task_2_vpc.id

  tags = {
    Name = "Task-2-IGW"
  }
}



# CRATING THE SUBNET IN THE VPC
resource "aws_subnet" "task_2_pub_subnet_1" {
  vpc_id     = aws_vpc.Task_2_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-1"
  }
}

resource "aws_subnet" "task_2_pub_subnet_2" {
  vpc_id     = aws_vpc.Task_2_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-2"
  }
}

resource "aws_subnet" "task_2_private_subnet_1" {
  vpc_id     = aws_vpc.Task_2_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private-Subnet-1"
  }
}

resource "aws_subnet" "task_2_private_subnet_2" {
  vpc_id     = aws_vpc.Task_2_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private-Subnet-2"
  }
}



# CREATING THE ROUTE TABLE FOR THE PUBLIC SUBNET 
resource "aws_route_table" "Public_Route_table" {
  vpc_id = aws_vpc.Task_2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Publec-Route-Table"
  }
}


#ASSOCIATEING WITH SUBNET 
resource "aws_route_table_association" "rt_association_1" {
  subnet_id      = aws_subnet.task_2_pub_subnet_1.id
  route_table_id = aws_route_table.Public_Route_table.id
}

resource "aws_route_table_association" "rt_association_2" {
  subnet_id      = aws_subnet.task_2_pub_subnet_2.id
  route_table_id = aws_route_table.Public_Route_table.id
}



#CREATING THE NAT GATEWAY 
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "Task-2-NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.task_2_pub_subnet_1.id

  tags = {
    Name = "Task-2-NAT-Gateway"
  }

  depends_on = [aws_internet_gateway.IGW]
}



# CREATING THE ROUTE TABLE FOR THE PRIVATE SUBNET 
resource "aws_route_table" "Private_Route_table" {
  vpc_id = aws_vpc.Task_2_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private-Route-Table"
  }
}


#ASSOCIATEING WITH SUBNET 
resource "aws_route_table_association" "rt_association_3" {
  subnet_id      = aws_subnet.task_2_private_subnet_1.id
  route_table_id = aws_route_table.Private_Route_table.id
}

resource "aws_route_table_association" "rt_association_4" {
  subnet_id      = aws_subnet.task_2_private_subnet_2.id
  route_table_id = aws_route_table.Private_Route_table.id
}

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Allow HTTP"
  vpc_id      = aws_vpc.Task_2_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # later restrict to ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB-SG"
  }
}



resource "aws_security_group" "private_sg" {
  name        = "private-ec2-sg"
  description = "Allow HTTP onley"
  vpc_id      = aws_vpc.Task_2_vpc.id

 ingress {
  description     = "HTTP from ALB"
  from_port       = 80
  to_port         = 80
  protocol        = "tcp"
  security_groups = [aws_security_group.lb_sg.id]
}

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-EC2-SG"
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = [
                        aws_subnet.task_2_pub_subnet_1.id,
                        aws_subnet.task_2_pub_subnet_2.id
                        ]

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
}

resource "aws_lb_target_group" "TG" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Task_2_vpc.id

 health_check {
  path                = "/"
  interval            = 30
  timeout             = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2
}

}

resource "aws_launch_template" "Template" {
  name = "EC2"

  image_id      = "ami-0e12ffc2dd465f6e4"
  instance_type = "t3.micro"

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  credit_specification {
    cpu_credits = "standard"
  }

  instance_initiated_shutdown_behavior = "terminate"

  metadata_options {
    http_tokens = "required"
  }

  monitoring {
    enabled = true
  }
user_data = base64encode(<<-EOF
#!/bin/bash
yum install -y nginx
systemctl enable nginx
systemctl start nginx
EOF
)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "ASG-Instance"
      Environment = "Dev"
      Project     = "Task-2"
    }
  }
}


resource "aws_autoscaling_group" "bar" {
  name                      = "Task2-ASG"

  desired_capacity          = 2
  max_size                  = 3
  min_size                  = 1

  target_group_arns = [aws_lb_target_group.TG.arn]

   launch_template {
    id      = aws_launch_template.Template.id
    version = "$Latest"
  }

  health_check_grace_period = 60
  health_check_type         = "ELB"
  vpc_zone_identifier       = [aws_subnet.task_2_private_subnet_2.id, aws_subnet.task_2_private_subnet_1.id]
  
  depends_on = [aws_lb_listener.http]

  tag {
    key                 = "Name"
    value               = "ASG"
    propagate_at_launch = true
  }
}


output "alb_dns_name" {
  value = aws_lb.test.dns_name
}