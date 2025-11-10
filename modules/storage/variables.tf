variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DynamoDB table."
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create."
  type        = string
}

variable "info_bucket_name" {
  description = "Name of the additional S3 bucket to create."
  type        = string
}

variable "oauth_table_name" {
  description = "Name of the OAuth transactions DynamoDB table."
  type        = string
}
