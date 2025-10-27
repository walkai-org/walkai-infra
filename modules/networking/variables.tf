variable "name" {
  description = "Friendly name used for tagging the VPC and subnets."
  default     = "Test"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  default     = "172.31.0.0/16"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  default     = "172.31.0.0/20"     
  type        = string
}

variable "public_subnet_az" {
  description = "Availability zone for the public subnet."
  default     = "us-east-1a"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  default     = "172.31.80.0/20"
  type        = string
}

variable "private_subnet_az" {
  description = "Availability zone for the private subnet."
  default     = "us-east-1b"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {env: "prod"}
}
