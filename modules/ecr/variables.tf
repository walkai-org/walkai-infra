variable "repository_name" {
  description = "Name of the ECR repository."
  type        = string
}

variable "users_repository_name" {
  description = "Name of the users ECR repository."
  type        = string
  default     = "walkai/users2"
}

variable "image_tag_mutability" {
  description = "Whether image tags can be overwritten."
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "Tags to apply to the ECR repositories."
  type        = map(string)
  default     = {}
}
