output "table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.cluster_cache.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.cluster_cache.arn
}

output "cluster_cache_table_name" {
  description = "Name of the cluster cache table."
  value       = aws_dynamodb_table.cluster_cache.name
}

output "cluster_cache_table_arn" {
  description = "ARN of the cluster cache DynamoDB table."
  value       = aws_dynamodb_table.cluster_cache.arn
}

output "oauth_table_name" {
  description = "Name of the OAuth transactions table."
  value       = aws_dynamodb_table.oauth_tx.name
}

output "oauth_table_arn" {
  description = "ARN of the OAuth transactions table."
  value       = aws_dynamodb_table.oauth_tx.arn
}

output "app_client_bucket_name" {
  description = "Name of the app client S3 bucket."
  value       = aws_s3_bucket.app_client.id
}

output "app_client_bucket_arn" {
  description = "ARN of the app client S3 bucket."
  value       = aws_s3_bucket.app_client.arn
}

output "app_client_bucket_domain_name" {
  description = "Regional domain name for the app client S3 bucket."
  value       = aws_s3_bucket.app_client.bucket_regional_domain_name
}

output "info_bucket_name" {
  description = "Name of the info S3 bucket."
  value       = aws_s3_bucket.info_site.id
}

output "info_bucket_arn" {
  description = "ARN of the info S3 bucket."
  value       = aws_s3_bucket.info_site.arn
}

output "bootstrap_first_user_secret_arn" {
  description = "Bootstrap secret ARN for the first user."
  value       = aws_secretsmanager_secret.bootstrap_first_user.arn
}

output "bootstrap_first_user_secret_name" {
  description = "Bootstrap secret name for the first user."
  value       = aws_secretsmanager_secret.bootstrap_first_user.name
}

output "db_instance_identifier" {
  description = "Identifier of the PostgreSQL instance."
  value       = try(aws_db_instance.walkai[0].id, null)
}

output "db_instance_endpoint" {
  description = "Endpoint of the PostgreSQL instance."
  value       = try(aws_db_instance.walkai[0].endpoint, null)
}

output "db_master_secret_arn" {
  description = "ARN of the Secrets Manager secret for the database master credentials."
  value       = try(aws_secretsmanager_secret.db_master[0].arn, null)
}

output "private_subnet_ids" {
  description = "Private subnet IDs used by storage resources."
  value       = var.private_subnet_ids
}

output "private_subnet_azs" {
  description = "Availability zones of the storage private subnets."
  value       = var.private_subnet_azs
}

output "db_security_group_id" {
  description = "Security group protecting the PostgreSQL instance."
  value       = try(aws_security_group.walkai_db[0].id, null)
}
