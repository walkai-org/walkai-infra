variable "region" {
  description = "AWS region for the prod storage stack."
  type        = string
  default     = "us-east-1"
}

variable "terraform_state_bucket" {
  description = "S3 bucket name where Terraform states are stored."
  type        = string
}

variable "k8s_cluster_url" {
  description = "Kubernetes cluster url."
  type        = string
}

variable "k8s_cluster_token" {
  description = "Kubernetes cluster token."
  type        = string
}

variable "bootstrap_first_user_email" {
  description = "First user email for bootstrap."
  type        = string
}

variable "base_domain" {
  description = "Base domain for API callback URLs."
  type        = string
}
