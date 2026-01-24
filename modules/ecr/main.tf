resource "aws_ecr_repository" "api" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true
  tags                 = var.tags
}

resource "aws_ecr_repository" "users" {
  name                 = var.users_repository_name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true
  tags                 = var.tags
}
