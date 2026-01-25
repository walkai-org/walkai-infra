variable "public_subnet_ids" {
  description = "Public subnet IDs where the ALB should be placed."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC identifier that owns the ALB security group."
  type        = string
}

variable "base_domain" {
  description = "Base domain name (e.g., walkaiorg.app)."
  type        = string
}

variable "external_dns" {
  description = "Whether the base domain is managed externally (create a hosted zone for walkai.<base_domain> to delegate)."
  type        = bool
  default     = true
}

variable "alb_acm_certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener (optional override)."
  type        = string
  default     = null
}

variable "enable_https" {
  description = "Whether to enable ACM validation and the HTTPS listener."
  type        = bool
  default     = true
}

variable "existing_https_listener_arn" {
  description = "Existing HTTPS listener ARN to reuse instead of creating a new one."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy to use for the HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "tags" {
  description = "Tags to apply to load balancer resources."
  type        = map(string)
  default     = {}
}
