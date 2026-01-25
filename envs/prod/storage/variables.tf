variable "region" {
  description = "AWS region for the prod storage stack."
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the prod VPC."
  type        = string
  default     = "172.31.0.0/16"
}

variable "bootstrap_first_user_email" {
  description = "Email del primer usuario para bootstrap."
  type        = string
}