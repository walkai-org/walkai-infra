variable "region" {
  description = "AWS region for the prod web distribution stack."
  type        = string
  default     = "us-east-1"
}

variable "app_client_bucket_name" {
  description = "Name of the S3 bucket that backs the web distribution origin."
  type        = string
  default     = "walkaiorg.app-client"
}

variable "tags" {
  description = "Tags to apply to the web distribution stack."
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "walkai"
  }
}
