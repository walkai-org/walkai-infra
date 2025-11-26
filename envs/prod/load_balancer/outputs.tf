output "alb_security_group_id" {
  description = "Security group protecting the ALB."
  value       = module.load_balancer.alb_security_group_id
}

output "alb_target_group_arn" {
  description = "ARN of the load balancer target group."
  value       = module.load_balancer.target_group_arn
}
