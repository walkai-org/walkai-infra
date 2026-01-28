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
  bucket = local.bucket_name
  force_destroy = true

  tags = merge(
    var.tags,
    {
      Name = local.bucket_name
    }
  )
}

resource "aws_s3_bucket" "info_site" {
  bucket = local.info_bucket_name
  force_destroy = true

  tags = merge(
    var.tags,
    {
      Name = local.info_bucket_name
    }
  )
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

locals {
  db_identifier = "${var.db_identifier}-${var.name_suffix}"
  bucket_name = "${var.bucket_name}-${var.name_suffix}"
  info_bucket_name = "${var.info_bucket_name}-${var.name_suffix}"
  k8s_cluster_credentials_secret_name = "${var.k8s_cluster_credentials_secret_name}-${var.name_suffix}"
  bootstrap_first_user_secret_name = "${var.bootstrap_first_user_secret_name}-${var.name_suffix}"
  db_allowed_security_group_ids = [
    for sg in var.db_allowed_security_group_ids : trimspace(sg)
    if try(length(trimspace(sg)), 0) > 0
  ]
}

resource "aws_secretsmanager_secret" "k8s_cluster_credentials" {
  name        = local.k8s_cluster_credentials_secret_name
  recovery_window_in_days = 0
  description = "Kubernetes cluster credentials."

  tags = merge(var.tags, {
    Name = local.k8s_cluster_credentials_secret_name
  })
}

resource "aws_secretsmanager_secret_version" "k8s_cluster_credentials" {
  secret_id = aws_secretsmanager_secret.k8s_cluster_credentials.id

  secret_string = jsonencode({
    cluster_url = var.k8s_cluster_url,
    cluster_token = var.k8s_cluster_token
  })
}


resource "aws_secretsmanager_secret" "bootstrap_first_user" {
  name        = local.bootstrap_first_user_secret_name
  recovery_window_in_days = 0
  description = "Bootstrap first user email for WalkAI."

  tags = merge(var.tags, {
    Name = local.bootstrap_first_user_secret_name
  })
}

resource "aws_secretsmanager_secret_version" "bootstrap_first_user" {
  secret_id = aws_secretsmanager_secret.bootstrap_first_user.id

  secret_string = jsonencode({
    email = var.bootstrap_first_user_email
  })
}

resource "aws_db_subnet_group" "walkai" {
  count       = var.create_database ? 1 : 0
  name_prefix = "${local.db_identifier}-subnets-"
  subnet_ids  = var.private_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${local.db_identifier}-subnet-group"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "walkai_db" {
  count       = var.create_database ? 1 : 0
  name        = "${local.db_identifier}-sg"
  description = "Security group for ${local.db_identifier}"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL access from within the VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
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
      Name = "${local.db_identifier}-sg"
    }
  )
}

resource "random_password" "db_master" {
  count   = var.create_database ? 1 : 0
  length  = 20
  special = true
  # Restrict to URL-safe special chars to keep the DSN valid without encoding.
  override_special = "!$&'()*+,;="
}

resource "aws_secretsmanager_secret" "db_master" {
  count       = var.create_database ? 1 : 0
  name_prefix = "${local.db_identifier}-credentials-"
  description = "Master credentials for ${local.db_identifier}"

  tags = merge(
    var.tags,
    {
      Name = "${local.db_identifier}-credentials"
    }
  )
}

resource "aws_secretsmanager_secret_version" "db_master" {
  count = var.create_database ? 1 : 0

  secret_id = aws_secretsmanager_secret.db_master[0].id
  secret_string = "postgresql+psycopg://${var.db_username}:${random_password.db_master[0].result}@${aws_db_instance.walkai[0].address}:5432/${var.db_name}"

  depends_on = [
    aws_db_instance.walkai
  ]
}

resource "aws_db_instance" "walkai" {
  count                  = var.create_database ? 1 : 0
  identifier             = local.db_identifier
  engine                 = "postgres"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_username
  password               = random_password.db_master[0].result
  db_subnet_group_name   = aws_db_subnet_group.walkai[0].name
  vpc_security_group_ids = [aws_security_group.walkai_db[0].id]
  availability_zone      = var.private_subnet_azs[0]
  multi_az                = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false
  storage_encrypted       = true
  backup_retention_period = 0 //check

  tags = merge(
    var.tags,
    {
      Name = local.db_identifier
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
