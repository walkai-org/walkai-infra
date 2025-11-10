variable "region" {
  description = "AWS region for the prod container registry stack."
  type        = string
  default     = "us-east-1"
}

variable "repository_name" {
  description = "Name of the ECR repository."
  type        = string
  default     = "walkai/api2"
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten."
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "Tags to apply to the container registry resources."
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "walkai"
  }
}
