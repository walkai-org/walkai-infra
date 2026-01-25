output "private_subnet_ids" {
  description = "Private subnet IDs used by the storage module."
  value       = module.storage.private_subnet_ids
}

output "private_subnet_azs" {
  description = "Availability zones corresponding to the private subnets."
  value       = module.storage.private_subnet_azs
}

output "app_client_bucket_name" {
  description = "Name of the app client S3 bucket."
  value       = module.storage.app_client_bucket_name
}

output "info_bucket_arn" {
  description = "Info bucket ARN."
  value       = module.storage.info_bucket_arn
}

output "bootstrap_first_user_secret_arn" {
  description = "Bootstrap secret ARN for the first user."
  value       = module.storage.bootstrap_first_user_secret_arn
}

output "bootstrap_first_user_secret_name" {
  description = "Bootstrap secret name for the first user."
  value       = module.storage.bootstrap_first_user_secret_name
}

output "db_master_secret_arn" {
  description = "ARN of the Secrets Manager secret for the database master credentials."
  value       = module.storage.db_master_secret_arn
}

output "cluster_cache_table_arn" {
  description = "Cluster cache DynamoDB table ARN."
  value       = module.storage.cluster_cache_table_arn
}

output "oauth_table_arn" {
  description = "OAuth DynamoDB table ARN."
  value       = module.storage.oauth_table_arn
}
