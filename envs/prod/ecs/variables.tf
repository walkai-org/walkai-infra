variable "region" {
  description = "AWS region for the prod ECS stack."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to ECS resources."
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "walkai"
  }
}
