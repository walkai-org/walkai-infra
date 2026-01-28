locals {
  repository_name       = "${var.repository_name}-${var.name_suffix}"
  users_repository_name = "${var.users_repository_name}-${var.name_suffix}"
}

resource "aws_ecr_repository" "api" {
  name                 = local.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true
  tags                 = var.tags
}

resource "aws_ecr_repository" "users" {
  name                 = local.users_repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true
  tags                 = var.tags
}
