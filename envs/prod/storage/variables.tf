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

variable "db_allowed_security_group_ids" {
  description = "Security groups that can reach the PostgreSQL instance."
  type        = list(string)
  default = [
    "sg-0157110b35a05f6e6",
    "sg-027efb60efcaeea5b"
  ]
}
