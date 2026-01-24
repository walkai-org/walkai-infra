output "repository_name" {
  description = "Name of the ECR repository."
  value       = aws_ecr_repository.api.name
}

output "repository_arn" {
  description = "ARN of the ECR repository."
  value       = aws_ecr_repository.api.arn
}

output "repository_url" {
  description = "Repository URL for docker pushes."
  value       = aws_ecr_repository.api.repository_url
}

output "users_repository_name" {
  description = "Name of the users ECR repository."
  value       = aws_ecr_repository.users.name
}

output "users_repository_arn" {
  description = "ARN of the users ECR repository."
  value       = aws_ecr_repository.users.arn
}

output "users_repository_url" {
  description = "Users repository URL for docker pushes."
  value       = aws_ecr_repository.users.repository_url
}
