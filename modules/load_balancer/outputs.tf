output "alb_arn" {
  description = "ARN of the application load balancer."
  value       = aws_lb.walkai_api_alb.arn
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer."
  value       = aws_lb.walkai_api_alb.dns_name
}

output "api_record_fqdn" {
  description = "FQDN of the Route53 record pointing to the ALB."
  value       = aws_route53_record.alb_api.fqdn
}

output "alb_zone_id" {
  description = "Route53 zone ID for the ALB."
  value       = aws_lb.walkai_api_alb.zone_id
}

output "alb_security_group_id" {
  description = "ID of the ALB security group."
  value       = aws_security_group.alb.id
}

output "target_group_arn" {
  description = "ARN of the primary target group."
  value       = aws_lb_target_group.api_ecs_tg.arn
}

output "base_domain" {
  description = "Base domain name."
  value       = var.base_domain
}

output "external_dns" {
  description = "Whether the base domain is managed externally."
  value       = var.external_dns
}

output "hosted_zone_id" {
  description = "Hosted zone ID for the base domain."
  value       = local.hosted_zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers for the hosted zone."
  value       = local.name_servers
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN covering walkai subdomains."
  value       = aws_acm_certificate.primary.arn
}

output "acm_validation_records" {
  description = "DNS records required to validate the ACM certificate."
  value       = local.acm_validation_records
}
