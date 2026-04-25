
module "vpc_ec2_stack" {
  source = "./modules" # Path to your module folder

  # Pass all required variables to the module
  vpc_cidr_block = var.vpc_cidr_block
  vpc_name       = var.vpc_name
  igw_name       = var.igw_name

  # Subnet configurations
  availability_zones      = var.availability_zones
  public_subnet_cidrs     = var.public_subnet_cidrs
  private_subnet_cidrs    = var.private_subnet_cidrs
  public_subnet_names     = var.public_subnet_names
  private_subnet_names    = var.private_subnet_names
  map_public_ip_on_launch = var.map_public_ip_on_launch

  # Route tables
  public_route_table_name  = var.public_route_table_name
  private_route_table_name = var.private_route_table_name

  # NAT Gateway
  nat_eip_name     = var.nat_eip_name
  nat_gateway_name = var.nat_gateway_name

  # Security Groups
  lb_sg_name             = var.lb_sg_name
  lb_sg_description      = var.lb_sg_description
  private_sg_name        = var.private_sg_name
  private_sg_description = var.private_sg_description

  # Load Balancer
  alb_name          = var.alb_name
  lb_internal       = var.lb_internal
  lb_type           = var.lb_type
  listener_port     = var.listener_port
  listener_protocol = var.listener_protocol

  # Target Group
  target_group_name     = var.target_group_name
  target_group_port     = var.target_group_port
  target_group_protocol = var.target_group_protocol

  # Health Check
  health_check_path     = var.health_check_path
  health_check_interval = var.health_check_interval
  health_check_timeout  = var.health_check_timeout
  healthy_threshold     = var.healthy_threshold
  unhealthy_threshold   = var.unhealthy_threshold

  # Launch Template
  ec2_template_name = var.ec2_template_name
  ami_id            = var.ami_id
  instance_type     = var.instance_type
  volume_size       = var.volume_size
  cpu_credits       = var.cpu_credits
  shutdown_behavior = var.shutdown_behavior
  http_tokens       = var.http_tokens

  # Auto Scaling Group
  asg_name                  = var.asg_name
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type

  # Tags
  environment       = var.environment
  project_name      = var.project_name
  instance_tag_name = var.instance_tag_name

  # User Data
  user_data_script = var.user_data_script
}

# Output the ALB DNS name from the module
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.vpc_ec2_stack.alb_dns_name
}