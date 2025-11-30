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
  description = "Tags to apply to the ECR repository."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC identifier that owns the ALB security group."
  type        = string
}

variable "alb_security_group_id" {
  description = "Security group allowed to reach the ECS tasks."
  type        = string
}

variable "alb_target_group_arn" {
  description = "ARN of the ALB target group to attach ECS service."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for ECS tasks."
  type        = list(string)
}
