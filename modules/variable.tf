
# variable "vpc_cidr_block" {
#     description = "for vpc cidr block"
# }

# variable "vpc" {
#   description = "for vpc name"
# }

# variable "IGW_name" {
#   description = "for IGW name"
# }

# variable "pub_subnet_1_name" {
#   description = "for public subnet 1 name"
# }

# variable "pub_subnet_1_cidr_block" {
#   description = "public subnet 1 cidr block range"
# }

# variable "pub_subnet_2_name" {
#   description = "for public subnet 2 name"
# }

# variable "pub_subnet_2_cidr_block" {
#   description = "public subnet 2 cidr block range"
# }

# variable "private_subnet_1_name" {
#   description = "for private subnet 1 name"
# }

# variable "private_subnet_1_cidr_block" {
#   description = "private subnet 1 cidr block range"
# }

# variable "private_subnet_2_name" {
#   description = "for private subnet 2 name"
# }

# variable "private_subnet_2_cidr_block" {
#   description = "private subnet 2 cidr block range"
# }

# variable "Public_Route_table_name" {
#   description = "for Public Route table name"
# }

# variable "nat_gateway_eip_name" {
#   description = "for nat gateway eip name"
# }

# variable "nat_gateway_name" {
#   description = "for nat gateway name"
# }

# variable "Private_Route_table_name" {
#   description = "for Private Route table name"
# }

# variable "ALB_SG_name" {
#   description = "for ALB SG name"
# }

# variable "EC2_SG_name" {
#   description = "for EC2 SG name"
# }

# variable "ALB_name" {
#   description = "ALB name"
# }

# variable "target_group_name" {
#   description = "Target Group Name"
# }

# variable "EC2_template_name" {
#   description = "EC2 template name"
# }

# variable "image_id" {
#   description = "image ami id"
# }

# variable "instance_type" {
#   description = "for instance type"
# }

# variable "availability_zone_1" {
#   description = "Availability Zone for subnet 1"
# }

# variable "availability_zone_2" {
#   description = "Availability Zone for subnet 2"
# }

# variable "map_public_ip" {
#   description = "Enable public IP on launch for public subnets"
#   type        = bool
# }

# variable "eip_domain" {
#   description = "EIP domain"
# }

# variable "lb_internal" {
#   description = "Is ALB internal or external"
#   type        = bool
# }

# variable "lb_type" {
#   description = "Load balancer type"
# }

# variable "listener_port" {
#   description = "Listener port"
# }

# variable "listener_protocol" {
#   description = "Listener protocol"
# }

# variable "target_group_port" {
#   description = "Target group port"
# }

# variable "target_group_protocol" {
#   description = "Target group protocol"
# }

# variable "health_check_path" {
#   description = "Health check path"
# }

# variable "health_check_interval" {
#   description = "Health check interval"
# }

# variable "health_check_timeout" {
#   description = "Health check timeout"
# }

# variable "healthy_threshold" {
#   description = "Healthy threshold"
# }

# variable "unhealthy_threshold" {
#   description = "Unhealthy threshold"
# }

# variable "volume_size" {
#   description = "EBS volume size"
# }

# variable "desired_capacity" {
#   description = "ASG desired capacity"
# }

# variable "max_size" {
#   description = "ASG max size"
# }

# variable "min_size" {
#   description = "ASG min size"
# }

# variable "health_check_grace_period" {
#   description = "ASG health check grace period"
# }


# Region Configuration
variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-south-1"
}

# VPC Configuration
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
  default     = "Task-2-dev-vpc"
}

# IGW Configuration
variable "igw_name" {
  description = "Name tag for Internet Gateway"
  type        = string
  default     = "Task-2-IGW"
}

# Subnet Configuration
variable "availability_zones" {
  description = "List of availability zones for subnets"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "public_subnet_names" {
  description = "Name tags for public subnets"
  type        = list(string)
  default     = ["Public-Subnet-1", "Public-Subnet-2"]
}

variable "private_subnet_names" {
  description = "Name tags for private subnets"
  type        = list(string)
  default     = ["Private-Subnet-1", "Private-Subnet-2"]
}

variable "map_public_ip_on_launch" {
  description = "Enable public IP on launch for public subnets"
  type        = bool
  default     = true
}

# Route Table Configuration
variable "public_route_table_name" {
  description = "Name tag for public route table"
  type        = string
  default     = "Public-Route-Table"
}

variable "private_route_table_name" {
  description = "Name tag for private route table"
  type        = string
  default     = "Private-Route-Table"
}

# NAT Gateway Configuration
variable "nat_eip_name" {
  description = "Name tag for NAT Gateway EIP"
  type        = string
  default     = "Task-2-NAT-EIP"
}

variable "nat_gateway_name" {
  description = "Name tag for NAT Gateway"
  type        = string
  default     = "Task-2-NAT-Gateway"
}

# Security Group Configuration
variable "lb_sg_name" {
  description = "Name for Load Balancer Security Group"
  type        = string
  default     = "lb-sg"
}

variable "lb_sg_description" {
  description = "Description for Load Balancer Security Group"
  type        = string
  default     = "Allow HTTP traffic to ALB"
}

variable "private_sg_name" {
  description = "Name for Private EC2 Security Group"
  type        = string
  default     = "private-ec2-sg"
}

variable "private_sg_description" {
  description = "Description for Private EC2 Security Group"
  type        = string
  default     = "Allow HTTP from ALB only"
}

# Load Balancer Configuration
variable "alb_name" {
  description = "Name for Application Load Balancer"
  type        = string
  default     = "test-lb-tf"
}

variable "lb_internal" {
  description = "Whether the ALB is internal or internet-facing"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Type of load balancer (application/network)"
  type        = string
  default     = "application"
}

variable "listener_port" {
  description = "Port for ALB listener"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for ALB listener"
  type        = string
  default     = "HTTP"
}

# Target Group Configuration
variable "target_group_name" {
  description = "Name for Target Group"
  type        = string
  default     = "tf-example-lb-tg"
}

variable "target_group_port" {
  description = "Port for Target Group"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Protocol for Target Group"
  type        = string
  default     = "HTTP"
}

# Health Check Configuration
variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive health check successes"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures"
  type        = number
  default     = 2
}

# Launch Template Configuration
variable "ec2_template_name" {
  description = "Name for EC2 Launch Template"
  type        = string
  default     = "EC2"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0e12ffc2dd465f6e4" # Amazon Linux 2 in ap-south-1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "EBS volume size in GB"
  type        = number
  default     = 8
}

variable "cpu_credits" {
  description = "CPU credits option for T2/T3 instances"
  type        = string
  default     = "standard"
}

variable "shutdown_behavior" {
  description = "Instance shutdown behavior"
  type        = string
  default     = "terminate"
}

variable "http_tokens" {
  description = "IMDSv2 token requirement"
  type        = string
  default     = "required"
}

# Auto Scaling Group Configuration
variable "asg_name" {
  description = "Name for Auto Scaling Group"
  type        = string
  default     = "Task2-ASG"
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "health_check_grace_period" {
  description = "Health check grace period for ASG"
  type        = number
  default     = 60
}

variable "health_check_type" {
  description = "Health check type for ASG"
  type        = string
  default     = "ELB"
}

# Tags
variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "Dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "Task-2"
}

variable "instance_tag_name" {
  description = "Name tag for instances"
  type        = string
  default     = "ASG-Instance"
}

# User Data Script
variable "user_data_script" {
  description = "User data script for EC2 instances"
  type        = string
  default     = <<-EOF
#!/bin/bash
yum install -y nginx
systemctl enable nginx
systemctl start nginx
EOF
}