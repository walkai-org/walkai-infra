variable "region" {
  description = "AWS region for the prod web distribution stack."
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags to apply to the web distribution stack."
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "walkai"
  }
}
