variable "region" {
  description = "AWS region for the prod ECR stack."
  type        = string
  default     = "us-east-1"
}

variable "repository_name" {
  description = "Name of the ECR repository."
  type        = string
  default     = "walkai/api"
}

variable "users_repository_name" {
  description = "Name of the users ECR repository."
  type        = string
  default     = "walkai/users"
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten."
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "Tags to apply to the ECR resources."
  type        = map(string)
  default = {
    Environment = "prod"
    Project     = "walkai"
  }
}
