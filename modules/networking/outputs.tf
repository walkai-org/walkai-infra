output "vpc_id" {
  description = "Identifier of the created VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "Identifier of the public subnet."
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "Identifier of the private subnet."
  value       = aws_subnet.private.id
}
