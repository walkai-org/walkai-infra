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
  value       = aws_route_table.private.id
}

output "subnet_ids" {
  description = "Identifiers for the created subnets keyed by logical name."
  value       = { for key, subnet in aws_subnet.subnets : key => subnet.id }
}
