variable "app_client_bucket_name" {
  description = "Name of the app client S3 bucket that backs the distribution origin."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the CloudFront resources."
  type        = map(string)
  default     = {}
}
