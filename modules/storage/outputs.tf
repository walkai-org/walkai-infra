output "table_name" {
  description = "Name of the DynamoDB table."
  value       = aws_dynamodb_table.cluster_cache.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table."
  value       = aws_dynamodb_table.cluster_cache.arn
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

output "db_instance_identifier" {
  description = "Identifier of the PostgreSQL instance."
  value       = aws_db_instance.walkai.id
}

output "db_instance_endpoint" {
  description = "Endpoint of the PostgreSQL instance."
  value       = aws_db_instance.walkai.endpoint
}

output "db_security_group_id" {
  description = "Security group protecting the PostgreSQL instance."
  value       = aws_security_group.walkai_db.id
}
