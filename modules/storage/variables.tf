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
