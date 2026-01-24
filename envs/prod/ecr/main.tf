provider "aws" {
  region = var.region
}

module "ecr" {
  source = "../../../modules/ecr"

  repository_name       = var.repository_name
  users_repository_name = var.users_repository_name
  image_tag_mutability  = var.image_tag_mutability
  tags                  = var.tags
}
