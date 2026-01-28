variable "name" {
  description = "Friendly name used for tagging the VPC."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "region" {
  description = "AWS region where networking resources are provisioned."
  type        = string
}

variable "subnets" {
  description = "Map of subnet definitions keyed by logical identifier."
  type = map(object({
    name                   = string
    cidr_block             = string
    availability_zone      = string
    public                 = bool
    map_public_ip_on_launch = optional(bool)
  }))
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "name_suffix" {
  description = "Shared suffix appended to unique resource names."
  type        = string
}
