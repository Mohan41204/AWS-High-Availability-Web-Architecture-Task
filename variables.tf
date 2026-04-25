# root/variables.tf
# This file DEFINES the variables (their types and descriptions)

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"  # Default value (optional)
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
  default     = "Task-2-dev-vpc"
}

variable "igw_name" {
  description = "Name for Internet Gateway"
  type        = string
  default     = "Task-2-IGW"
}

variable "availability_zones" {
  description = "List of availability zones"
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
  description = "Enable public IP on launch"
  type        = bool
  default     = true
}

variable "public_route_table_name" {
  description = "Name for public route table"
  type        = string
  default     = "Public-Route-Table"
}

variable "private_route_table_name" {
  description = "Name for private route table"
  type        = string
  default     = "Private-Route-Table"
}

variable "nat_eip_name" {
  description = "Name for NAT EIP"
  type        = string
  default     = "Task-2-NAT-EIP"
}

variable "nat_gateway_name" {
  description = "Name for NAT Gateway"
  type        = string
  default     = "Task-2-NAT-Gateway"
}

variable "lb_sg_name" {
  description = "Load balancer security group name"
  type        = string
  default     = "lb-sg"
}

variable "lb_sg_description" {
  description = "Load balancer security group description"
  type        = string
  default     = "Allow HTTP traffic to ALB"
}

variable "private_sg_name" {
  description = "Private EC2 security group name"
  type        = string
  default     = "private-ec2-sg"
}

variable "private_sg_description" {
  description = "Private EC2 security group description"
  type        = string
  default     = "Allow HTTP from ALB only"
}

variable "alb_name" {
  description = "ALB name"
  type        = string
  default     = "test-lb-tf"
}

variable "lb_internal" {
  description = "Is ALB internal"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Load balancer type"
  type        = string
  default     = "application"
}

variable "listener_port" {
  description = "Listener port"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener protocol"
  type        = string
  default     = "HTTP"
}

variable "target_group_name" {
  description = "Target group name"
  type        = string
  default     = "tf-example-lb-tg"
}

variable "target_group_port" {
  description = "Target group port"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "Target group protocol"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "Health check interval"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Healthy threshold"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold"
  type        = number
  default     = 2
}

variable "ec2_template_name" {
  description = "EC2 launch template name"
  type        = string
  default     = "EC2"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default     = "ami-0e12ffc2dd465f6e4"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "EBS volume size"
  type        = number
  default     = 8
}

variable "cpu_credits" {
  description = "CPU credits"
  type        = string
  default     = "standard"
}

variable "shutdown_behavior" {
  description = "Shutdown behavior"
  type        = string
  default     = "terminate"
}

variable "http_tokens" {
  description = "HTTP tokens requirement"
  type        = string
  default     = "required"
}

variable "asg_name" {
  description = "ASG name"
  type        = string
  default     = "Task2-ASG"
}

variable "desired_capacity" {
  description = "Desired capacity"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Max size"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Min size"
  type        = number
  default     = 1
}

variable "health_check_grace_period" {
  description = "Health check grace period"
  type        = number
  default     = 60
}

variable "health_check_type" {
  description = "Health check type"
  type        = string
  default     = "ELB"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Dev"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "Task-2"
}

variable "instance_tag_name" {
  description = "Instance tag name"
  type        = string
  default     = "ASG-Instance"
}

variable "user_data_script" {
  description = "User data script"
  type        = string
  default     = <<-EOF
#!/bin/bash
yum install -y nginx
systemctl enable nginx
systemctl start nginx
EOF
}