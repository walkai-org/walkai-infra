variable "public_subnet_ids" {
  description = "Public subnet IDs where the ALB should be placed."
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC identifier that owns the ALB security group."
  type        = string
}

variable "alb_acm_certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener."
  type        = string
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
