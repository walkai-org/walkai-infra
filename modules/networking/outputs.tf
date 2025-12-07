output "vpc_id" {
  description = "Identifier of the created VPC."
  value       = aws_vpc.this.id
}

output "internet_gateway_id" {
  description = "Identifier of the internet gateway attached to the VPC."
  value       = aws_internet_gateway.this.id
}

output "public_route_table_id" {
  description = "Identifier of the public main route table."
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Identifier of the private main route table."
  value       = aws_default_route_table.private.id
}

output "s3_gateway_endpoint_id" {
  description = "Identifier of the S3 gateway VPC endpoint."
  value       = aws_vpc_endpoint.s3.id
}

output "dynamodb_gateway_endpoint_id" {
  description = "Identifier of the DynamoDB gateway VPC endpoint."
  value       = aws_vpc_endpoint.dynamodb.id
}

output "subnet_ids" {
  description = "Identifiers for the created subnets keyed by logical name."
  value       = { for key, subnet in aws_subnet.subnets : key => subnet.id }
}

output "default_security_group_id" {
  description = "Identifier of the default security group associated with the VPC."
  value       = aws_vpc.this.default_security_group_id
}

output "subnet_azs" {
  description = "Availability zones for each subnet keyed by logical name."
  value       = { for key, subnet in aws_subnet.subnets : key => subnet.availability_zone }
}
