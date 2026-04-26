output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.vpc_ec2_stack.alb_dns_name
}