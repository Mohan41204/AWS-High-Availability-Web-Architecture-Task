# #CREATING THE VPC
# resource "aws_vpc" "vpc" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"

#   tags = {
#     Name = "Task-2-dev-vpc"
#   }
# }



# # CREATING THE IGW AND ATTACHED TO THE VPC
# resource "aws_internet_gateway" "IGW" {
#   vpc_id = aws_vpc.vpc.id

#   tags = {
#     Name = "Task-2-IGW"
#   }
# }



# # CRATING THE SUBNET IN THE VPC
# resource "aws_subnet" "pub_subnet_1" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "ap-south-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "Public-Subnet-1"
#   }
# }

# resource "aws_subnet" "pub_subnet_2" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "ap-south-1b"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "Public-Subnet-2"
#   }
# }

# resource "aws_subnet" "private_subnet_1" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "ap-south-1a"

#   tags = {
#     Name = "Private-Subnet-1"
#   }
# }

# resource "aws_subnet" "private_subnet_2" {
#   vpc_id     = aws_vpc.vpc.id
#   cidr_block = "10.0.4.0/24"
#   availability_zone = "ap-south-1b"

#   tags = {
#     Name = "Private-Subnet-2"
#   }
# }



# # CREATING THE ROUTE TABLE FOR THE PUBLIC SUBNET 
# resource "aws_route_table" "Public_Route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.IGW.id
#   }

#   tags = {
#     Name = "Publec-Route-Table"
#   }
# }


# #ASSOCIATEING WITH SUBNET 
# resource "aws_route_table_association" "rt_association_1" {
#   subnet_id      = aws_subnet.pub_subnet_1.id
#   route_table_id = aws_route_table.Public_Route_table.id
# }

# resource "aws_route_table_association" "rt_association_2" {
#   subnet_id      = aws_subnet.pub_subnet_2.id
#   route_table_id = aws_route_table.Public_Route_table.id
# }



# #CREATING THE NAT GATEWAY 
# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "Task-2-NAT-EIP"
#   }
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.pub_subnet_1.id

#   tags = {
#     Name = "Task-2-NAT-Gateway"
#   }

#   depends_on = [aws_internet_gateway.IGW]
# }



# # CREATING THE ROUTE TABLE FOR THE PRIVATE SUBNET 
# resource "aws_route_table" "Private_Route_table" {
#   vpc_id = aws_vpc.vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat_gw.id
#   }

#   tags = {
#     Name = "Private-Route-Table"
#   }
# }


# #ASSOCIATEING WITH SUBNET 
# resource "aws_route_table_association" "rt_association_3" {
#   subnet_id      = aws_subnet.private_subnet_1.id
#   route_table_id = aws_route_table.Private_Route_table.id
# }

# resource "aws_route_table_association" "rt_association_4" {
#   subnet_id      = aws_subnet.private_subnet_2.id
#   route_table_id = aws_route_table.Private_Route_table.id
# }

# resource "aws_security_group" "lb_sg" {
#   name        = "lb-sg"
#   description = "Allow HTTP"
#   vpc_id      = aws_vpc.vpc.id

#   ingress {
#     description = "HTTP"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # later restrict to ALB
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "LB-SG"
#   }
# }



# resource "aws_security_group" "private_sg" {
#   name        = "private-ec2-sg"
#   description = "Allow HTTP onley"
#   vpc_id      = aws_vpc.vpc.id

#  ingress {
#   description     = "HTTP from ALB"
#   from_port       = 80
#   to_port         = 80
#   protocol        = "tcp"
#   security_groups = [aws_security_group.lb_sg.id]
# }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Private-EC2-SG"
#   }
# }

# resource "aws_lb" "test" {
#   name               = "test-lb-tf"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [
#                         aws_subnet.pub_subnet_1.id,
#                         aws_subnet.pub_subnet_2.id
#                         ]

#   enable_deletion_protection = false

#   tags = {
#     Environment = "production"
#   }
# }

# resource "aws_lb_listener" "http" {
#   load_balancer_arn = aws_lb.test.arn
#   port              = 80
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.TG.arn
#   }
# }

# resource "aws_lb_target_group" "TG" {
#   name     = "tf-example-lb-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.vpc.id

#  health_check {
#   path                = "/"
#   interval            = 30
#   timeout             = 5
#   healthy_threshold   = 2
#   unhealthy_threshold = 2
# }

# }

# resource "aws_launch_template" "Template" {
#   name = "EC2"

#   image_id      = "ami-0e12ffc2dd465f6e4"
#   instance_type = "t3.micro"

#   vpc_security_group_ids = [aws_security_group.private_sg.id]

#   block_device_mappings {
#     device_name = "/dev/xvda"

#     ebs {
#       volume_size = 8
#     }
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   instance_initiated_shutdown_behavior = "terminate"

#   metadata_options {
#     http_tokens = "required"
#   }

#   monitoring {
#     enabled = true
#   }
# user_data = base64encode(<<-EOF
# #!/bin/bash
# yum install -y nginx
# systemctl enable nginx
# systemctl start nginx
# EOF
# )

#   tag_specifications {
#     resource_type = "instance"

#     tags = {
#       Name        = "ASG-Instance"
#       Environment = "Dev"
#       Project     = "Task-2"
#     }
#   }
# }


# resource "aws_autoscaling_group" "bar" {
#   name                      = "Task2-ASG"

#   desired_capacity          = 2
#   max_size                  = 3
#   min_size                  = 1

#   target_group_arns = [aws_lb_target_group.TG.arn]

#    launch_template {
#     id      = aws_launch_template.Template.id
#     version = "$Latest"
#   }

#   health_check_grace_period = 60
#   health_check_type         = "ELB"
#   vpc_zone_identifier       = [aws_subnet.private_subnet_2.id, aws_subnet.private_subnet_1.id]
  
#   depends_on = [aws_lb_listener.http]

#   tag {
#     key                 = "Name"
#     value               = "ASG"
#     propagate_at_launch = true
#   }
# }







# CREATING THE VPC
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

# CREATING THE IGW AND ATTACHED TO THE VPC
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = var.igw_name
  }
}

# CREATING PUBLIC SUBNETS DYNAMICALLY
resource "aws_subnet" "pub_subnet" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = var.map_public_ip_on_launch

  tags = {
    Name = var.public_subnet_names[count.index]
  }
}

# CREATING PRIVATE SUBNETS DYNAMICALLY
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = var.private_subnet_names[count.index]
  }
}

# CREATING THE ROUTE TABLE FOR THE PUBLIC SUBNET
resource "aws_route_table" "Public_Route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}

# ASSOCIATING PUBLIC SUBNETS WITH PUBLIC ROUTE TABLE
resource "aws_route_table_association" "public_rt_association" {
  count = length(aws_subnet.pub_subnet)

  subnet_id      = aws_subnet.pub_subnet[count.index].id
  route_table_id = aws_route_table.Public_Route_table.id
}

# CREATING THE NAT GATEWAY
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = var.nat_eip_name
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_subnet[0].id

  tags = {
    Name = var.nat_gateway_name
  }

  depends_on = [aws_internet_gateway.IGW]
}

# CREATING THE ROUTE TABLE FOR THE PRIVATE SUBNET
resource "aws_route_table" "Private_Route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = var.private_route_table_name
  }
}

# ASSOCIATING PRIVATE SUBNETS WITH PRIVATE ROUTE TABLE
resource "aws_route_table_association" "private_rt_association" {
  count = length(aws_subnet.private_subnet)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.Private_Route_table.id
}

# SECURITY GROUP FOR LOAD BALANCER
resource "aws_security_group" "lb_sg" {
  name        = var.lb_sg_name
  description = var.lb_sg_description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTP"
    from_port   = var.listener_port
    to_port     = var.listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.lb_sg_name
  }
}

# SECURITY GROUP FOR PRIVATE EC2 INSTANCES
resource "aws_security_group" "private_sg" {
  name        = var.private_sg_name
  description = var.private_sg_description
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description     = "HTTP from ALB"
    from_port       = var.target_group_port
    to_port         = var.target_group_port
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
    Name = var.private_sg_name
  }
}

# APPLICATION LOAD BALANCER
resource "aws_lb" "test" {
  name               = var.alb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = aws_subnet.pub_subnet[*].id

  enable_deletion_protection = false

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# ALB LISTENER
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG.arn
  }
}

# TARGET GROUP
resource "aws_lb_target_group" "TG" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = aws_vpc.vpc.id

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
  }
}

# LAUNCH TEMPLATE
resource "aws_launch_template" "Template" {
  name = var.ec2_template_name

  image_id      = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.volume_size
    }
  }

  credit_specification {
    cpu_credits = var.cpu_credits
  }

  instance_initiated_shutdown_behavior = var.shutdown_behavior

  metadata_options {
    http_tokens = var.http_tokens
  }

  monitoring {
    enabled = true
  }

  user_data = base64encode(var.user_data_script)

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = var.instance_tag_name
      Environment = var.environment
      Project     = var.project_name
    }
  }
}

# AUTO SCALING GROUP
resource "aws_autoscaling_group" "bar" {
  name = var.asg_name

  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  target_group_arns = [aws_lb_target_group.TG.arn]

  launch_template {
    id      = aws_launch_template.Template.id
    version = "$Latest"
  }

  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  vpc_zone_identifier       = aws_subnet.private_subnet[*].id

  depends_on = [aws_lb_listener.http]

  tag {
    key                 = "Name"
    value               = var.asg_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = var.project_name
    propagate_at_launch = true
  }
}