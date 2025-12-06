output "private_subnet_azs" {
  description = "Availability zones for each private subnet."
  value       = data.terraform_remote_state.networking.outputs.subnet_azs
}
