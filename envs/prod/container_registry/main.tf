provider "aws" {
  region = var.region
}

module "container_registry" {
  source = "../../../modules/container_registry"

  repository_name      = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags
}
