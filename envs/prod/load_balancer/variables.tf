variable "region" {
  description = "AWS region for the prod load balancer stack."
  type        = string
  default     = "us-east-1"
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

variable "enable_https" {
  description = "Whether to enable ACM validation and the HTTPS listener."
  type        = bool
  default     = true
}

variable "ssl_policy" {
  description = "SSL policy for the ALB HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "tags" {
  description = "Tags to apply to ALB resources."
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "walkai"
  }
}
