output "alb_security_group_id" {
  description = "Security group protecting the ALB."
  value       = module.load_balancer.alb_security_group_id
}

output "alb_target_group_arn" {
  description = "ARN of the load balancer target group."
  value       = module.load_balancer.target_group_arn
}

output "alb_dns_name" {
  description = "DNS name for the load balancer."
  value       = module.load_balancer.alb_dns_name
}

output "api_record_fqdn" {
  description = "Route53 record FQDN for the API."
  value       = module.load_balancer.api_record_fqdn
}

output "alb_zone_id" {
  description = "Route53 zone ID for the ALB."
  value       = module.load_balancer.alb_zone_id
}

output "base_domain" {
  description = "Base domain name."
  value       = module.load_balancer.base_domain
}

output "external_dns" {
  description = "Whether the base domain is managed externally."
  value       = module.load_balancer.external_dns
}

output "hosted_zone_id" {
  description = "Hosted zone ID for the base domain."
  value       = module.load_balancer.hosted_zone_id
}

output "hosted_zone_name_servers" {
  description = "Name servers for the hosted zone."
  value       = module.load_balancer.hosted_zone_name_servers
}

output "acm_certificate_arn" {
  description = "ACM certificate ARN covering walkai subdomains."
  value       = module.load_balancer.acm_certificate_arn
}

output "acm_validation_records" {
  description = "DNS records required to validate the ACM certificate."
  value       = module.load_balancer.acm_validation_records
}
