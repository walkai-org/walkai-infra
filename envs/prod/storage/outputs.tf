output "cluster_cache_table_arn" {
  description = "Cluster cache DynamoDB table ARN."
  value       = module.storage.cluster_cache_table_arn
}

output "oauth_table_arn" {
  description = "OAuth DynamoDB table ARN."
  value       = module.storage.oauth_table_arn
}
