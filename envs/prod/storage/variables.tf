variable "region" {
  description = "AWS region for the prod storage stack."
  type        = string
  default     = "us-east-1"
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
