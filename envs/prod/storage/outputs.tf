output "private_subnet_ids" {
  description = "Private subnet IDs used by the storage module."
  value       = module.storage.private_subnet_ids
}

output "private_subnet_azs" {
  description = "Availability zones corresponding to the private subnets."
  value       = module.storage.private_subnet_azs
}

output "info_bucket_arn" {
  description = "Info bucket ARN."
  value       = module.storage.info_bucket_arn
}

output "cluster_cache_table_arn" {
  description = "Cluster cache DynamoDB table ARN."
  value       = module.storage.cluster_cache_table_arn
}

output "oauth_table_arn" {
  description = "OAuth DynamoDB table ARN."
  value       = module.storage.oauth_table_arn
}
