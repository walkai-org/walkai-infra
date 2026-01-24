output "vpc_id" {
  description = "Identifier of the VPC created by the networking module."
  value       = module.networking.vpc_id
}

output "subnet_ids" {
  description = "Subnets created by the networking module keyed by logical name."
  value       = module.networking.subnet_ids
}

output "subnet_azs" {
  description = "Availability zones for each subnet keyed by logical name."
  value       = module.networking.subnet_azs
}

output "default_security_group_id" {
  description = "Default security group ID associated with the VPC."
  value       = module.networking.default_security_group_id
}
