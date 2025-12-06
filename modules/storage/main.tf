resource "aws_dynamodb_table" "cluster_cache" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name = var.table_name
    }
  )
}

resource "aws_dynamodb_table" "oauth_tx" {
  name         = var.oauth_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"

  attribute {
    name = "pk"
    type = "S"
  }

  tags = merge(
    var.tags,
    {
      Name = var.oauth_table_name
    }
  )
}

resource "aws_s3_bucket" "app_client" {
  bucket = var.bucket_name

  tags = merge(
    var.tags,
    {
      Name = var.bucket_name
    }
  )
}

resource "aws_s3_bucket" "info_site" {
  bucket = var.info_bucket_name

  tags = merge(
    var.tags,
    {
      Name = var.info_bucket_name
    }
  )
}

locals {
  db_allowed_security_group_ids = [
    for sg in var.db_allowed_security_group_ids : trimspace(sg)
    if try(length(trimspace(sg)), 0) > 0
  ]
}

resource "aws_db_subnet_group" "walkai" {
  count       = var.create_database ? 1 : 0
  name_prefix = "${var.db_identifier}-subnets-"
  subnet_ids  = var.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.db_identifier}-subnet-group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "walkai_db" {
  count       = var.create_database ? 1 : 0
  name        = "${var.db_identifier}-sg"
  description = "Security group for ${var.db_identifier}"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL access from within the VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.db_identifier}-sg"
    }
  )
}

resource "random_password" "db_master" {
  count   = var.create_database ? 1 : 0
  length  = 20
  special = true
}

resource "aws_db_instance" "walkai" {
  count                  = var.create_database ? 1 : 0
  identifier              = var.db_identifier
  engine                  = "postgres"
  instance_class          = var.db_instance_class
  allocated_storage       = 20
  db_name                 = var.db_name
  username                = var.db_username
  password                = try(random_password.db_master[0].result, null)
  db_subnet_group_name    = try(aws_db_subnet_group.walkai[0].name, null)
  vpc_security_group_ids  = try([aws_security_group.walkai_db[0].id], [])
  multi_az                = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = true
  backup_retention_period = 0 //check

  tags = merge(
    var.tags,
    {
      Name = var.db_identifier
    }
  )
}

resource "aws_security_group_rule" "db_ingress_from_allowed_sgs" {
  for_each = var.create_database ? toset(local.db_allowed_security_group_ids) : []

  type              = "ingress"
  security_group_id = aws_security_group.walkai_db[0].id
  from_port         = 5432
  to_port           = 5432
  protocol          = "tcp"
  source_security_group_id = each.value
}
