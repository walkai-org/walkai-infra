variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "172.31.0.0/16"
}
