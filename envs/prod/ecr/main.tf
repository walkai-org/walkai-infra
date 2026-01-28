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

module "ecr" {
  source = "../../../modules/ecr"

  repository_name       = var.repository_name
  users_repository_name = var.users_repository_name
  image_tag_mutability  = var.image_tag_mutability
  name_suffix           = data.terraform_remote_state.networking.outputs.name_suffix
  tags                  = var.tags
}
