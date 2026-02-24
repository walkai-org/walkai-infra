variable "region" {
  description = "AWS region for the prod ECS stack."
  type        = string
  default     = "us-east-1"
}

variable "terraform_state_bucket" {
  description = "S3 bucket name where Terraform states are stored."
  type        = string
}

variable "tags" {
  description = "Tags to apply to ECS resources."
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "walkai"
  }
}
