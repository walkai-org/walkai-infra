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
  public_subnet_ids = [
    for name, id in data.terraform_remote_state.networking.outputs.subnet_ids :
    id if startswith(name, "public")
  ]
}

module "load_balancer" {
  source = "../../../modules/load_balancer"

  public_subnet_ids       = local.public_subnet_ids
  vpc_id                  = data.terraform_remote_state.networking.outputs.vpc_id
  alb_acm_certificate_arn = var.alb_acm_certificate_arn
  ssl_policy              = var.ssl_policy
  tags                    = var.tags

  depends_on = [
    data.terraform_remote_state.networking
  ]
}
