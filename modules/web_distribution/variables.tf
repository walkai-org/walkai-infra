variable "app_client_bucket_name" {
  description = "Name of the app client S3 bucket that backs the distribution origin."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for the CloudFront distribution."
  type        = string
}

variable "aliases" {
  description = "Alternate domain names (CNAMEs) for the distribution."
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID where the alias record should live."
  type        = string
}

variable "web_domain" {
  description = "Domain name to alias to the CloudFront distribution."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the CloudFront resources."
  type        = map(string)
  default     = {}
}
