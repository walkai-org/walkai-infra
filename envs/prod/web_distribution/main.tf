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

data "terraform_remote_state" "load_balancer" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/load_balancer/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

locals {
  app_client_bucket_name = coalesce(
    var.app_client_bucket_name,
    try(data.terraform_remote_state.storage.outputs.app_client_bucket_name, null)
  )

  base_domain   = data.terraform_remote_state.load_balancer.outputs.base_domain
  web_domain    = "walkai.${local.base_domain}"
}

module "web_distribution" {
  source = "../../../modules/web_distribution"

  app_client_bucket_name = local.app_client_bucket_name
  acm_certificate_arn    = data.terraform_remote_state.load_balancer.outputs.acm_certificate_arn
  aliases                = [local.web_domain]
  hosted_zone_id         = data.terraform_remote_state.load_balancer.outputs.hosted_zone_id
  web_domain             = local.web_domain
  tags                   = var.tags

  depends_on = [
    data.terraform_remote_state.storage,
    data.terraform_remote_state.load_balancer
  ]
}
