variable "region" {
  description = "AWS region for the prod load balancer stack."
  type        = string
  default     = "us-east-1"
}

variable "public_subnet_ids" {
  description = "Public subnets for the ALB."
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  description = "VPC ID that hosts the ALB."
  type        = string
  default     = ""
}

variable "alb_acm_certificate_arn" {
  description = "ACM certificate ARN for the ALB HTTPS listener."
  type        = string
  default     = "arn:aws:acm:us-east-1:864683107176:certificate/86052bbd-79a2-4037-8ef2-b749fdf89197"
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
