provider "aws" {
  region = var.region
}

data "terraform_remote_state" "storage" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/storage/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  app_client_bucket_name = coalesce(
    var.app_client_bucket_name,
    data.terraform_remote_state.storage.outputs.app_client_bucket_name
  )
}

module "web_distribution" {
  source = "../../../modules/web_distribution"

  app_client_bucket_name = local.app_client_bucket_name
  tags                   = var.tags

  depends_on = [data.terraform_remote_state.storage]
}
