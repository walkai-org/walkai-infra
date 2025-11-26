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

data "terraform_remote_state" "load_balancer" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/load_balancer/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "container_registry" {
  source = "../../../modules/container_registry"

  repository_name       = var.repository_name
  users_repository_name = var.users_repository_name
  image_tag_mutability  = var.image_tag_mutability
  tags                  = var.tags
  vpc_id                = data.terraform_remote_state.networking.outputs.vpc_id
  alb_security_group_id = data.terraform_remote_state.load_balancer.outputs.alb_security_group_id

  depends_on = [
    data.terraform_remote_state.networking,
    data.terraform_remote_state.load_balancer
  ]
}
