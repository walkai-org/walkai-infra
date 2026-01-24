output "repository_name" {
  description = "Name of the ECR repository."
  value       = module.ecr.repository_name
}

output "repository_arn" {
  description = "ARN of the ECR repository."
  value       = module.ecr.repository_arn
}

output "repository_url" {
  description = "Repository URL for docker pushes."
  value       = module.ecr.repository_url
}

output "users_repository_name" {
  description = "Name of the users ECR repository."
  value       = module.ecr.users_repository_name
}

output "users_repository_arn" {
  description = "ARN of the users ECR repository."
  value       = module.ecr.users_repository_arn
}

output "users_repository_url" {
  description = "Users repository URL for docker pushes."
  value       = module.ecr.users_repository_url
}
