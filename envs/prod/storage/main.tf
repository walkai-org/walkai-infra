provider "aws" {
  region = var.region
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/networking/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  private_subnet_ids = [
    for name, id in data.terraform_remote_state.networking.outputs.subnet_ids :
    id if startswith(name, "private")
  ]

  db_allowed_security_group_ids = compact([
    try(data.terraform_remote_state.networking.outputs.default_security_group_id, null)
  ])

  private_subnet_azs = [
    for name, id in data.terraform_remote_state.networking.outputs.subnet_ids :
    data.terraform_remote_state.networking.outputs.subnet_azs[name]
    if startswith(name, "private")
  ]
}

module "storage" {
  source = "../../../modules/storage"

  table_name        = "walkai_cluster_cache"
  oauth_table_name  = "walkai_oauth_tx"
  bucket_name       = "walkaiorg.app-client2"
  info_bucket_name  = "walkai-info2"
  vpc_id            = data.terraform_remote_state.networking.outputs.vpc_id
  private_subnet_ids = local.private_subnet_ids
  private_subnet_azs = local.private_subnet_azs
  db_allowed_security_group_ids = local.db_allowed_security_group_ids
  k8s_cluster_url = var.k8s_cluster_url
  k8s_cluster_token = var.k8s_cluster_token
  bootstrap_first_user_email = var.bootstrap_first_user_email

  tags = {
    Environment = "prod"
    Project     = "walkai"
  }
}
