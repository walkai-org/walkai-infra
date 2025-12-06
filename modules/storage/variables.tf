variable "table_name" {
  description = "Name of the DynamoDB table."
  type        = string
}

variable "tags" {
  description = "Tags to apply to the DynamoDB table."
  type        = map(string)
  default     = {}
}

variable "bucket_name" {
  description = "Name of the S3 bucket to create."
  type        = string
}

variable "info_bucket_name" {
  description = "Name of the additional S3 bucket to create."
  type        = string
}

variable "oauth_table_name" {
  description = "Name of the OAuth transactions DynamoDB table."
  type        = string
}

variable "vpc_id" {
  description = "Identifier of the VPC where the storage services run."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet identifiers where data services should reside."
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "CIDR block of the VPC for use in security group rules."
  type        = string
}

variable "db_identifier" {
  description = "Identifier for the storage PostgreSQL instance."
  type        = string
  default     = "walkai-db2"
}

variable "db_name" {
  description = "Initial database name for the PostgreSQL instance."
  type        = string
  default     = "walkaidb"
}

variable "db_username" {
  description = "Master username for the PostgreSQL instance."
  type        = string
  default     = "walkaiadmin"
}

variable "db_instance_class" {
  description = "Instance type for the PostgreSQL instance."
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allowed_security_group_ids" {
  description = "Security group IDs allowed to access the database."
  type        = list(string)
  default     = []
}

variable "create_database" {
  description = "Whether to create the PostgreSQL database resources."
  type        = bool
  default     = true
}
