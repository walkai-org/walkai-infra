output "alb_arn" {
  description = "ARN of the application load balancer."
  value       = aws_lb.walkai_api_alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.walkai_api_alb.dns_name
}

output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ARN of the primary target group."
  value       = aws_lb_target_group.api_ecs_tg.arn
}
