resource "aws_ecr_repository" "api" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags
}
