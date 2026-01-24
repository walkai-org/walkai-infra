variable "repository_name" {
  description = "Name of the API ECR repository, used for container naming."
  type        = string
}

variable "repository_url" {
  description = "Repository URL for the API image."
  type        = string
}

variable "users_repository_arn" {
  description = "ARN of the users ECR repository."
  type        = string
}

variable "tags" {
  description = "Tags to apply to ECS resources."
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

variable "info_bucket_arn" {
  description = "ARN of the info bucket containing environment files."
  type        = string
}

variable "cluster_cache_table_arn" {
  description = "ARN of the DynamoDB cluster cache table."
  type        = string
}

variable "oauth_table_arn" {
  description = "ARN of the OAuth DynamoDB table."
  type        = string
}
