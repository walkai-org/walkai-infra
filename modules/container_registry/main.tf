resource "aws_ecr_repository" "api" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags
}

resource "aws_ecr_repository" "users" {
  name                 = var.users_repository_name
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags
}


resource "aws_security_group" "sg_ecs" {
  name        = "sg_ecs_terraform"
  description = "Allows ecs task communication"
  vpc_id      = var.vpc_id

  ingress {
    description     = "TCP 8000 from source SG"
    protocol        = "tcp"
    from_port       = 8000
    to_port         = 8000
    security_groups = [var.alb_security_group_id]
  }

  egress {
    description = "All outbound IPv4"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "sg_ecs"
    }
  )
}
