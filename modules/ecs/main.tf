locals {
  api_container_name = replace(var.repository_name, "/", "-")
  env_file_arn       = "${var.info_bucket_arn}/api/.env"
}

data "aws_lb_target_group" "api" {
  arn = var.alb_target_group_arn
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

resource "aws_ecs_cluster" "walkai" {
  name = "walkai-cluster2"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_iam_role" "task_execution_role" {
  name = "task_execution_role2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "task_execution_role_env_policy" {
  name = "get_web_api_env2"
  role = aws_iam_role.task_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowReadEnvFileFromS3"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "${var.info_bucket_arn}/api/.env"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_execution_role_policy" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "walkai_api_task_role" {
  name = "walkai_api_task_role2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_policy" "ecr_access_policy" {
  name        = "ecr_access2"
  description = "Custom ECR access policy for the walkai API task role."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AuthToken"
        Effect = "Allow"
        Action = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "PushOnlyToSpecificRepos"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:DescribeImages",
          "ecr:ListImages"
        ]
        Resource = [
          var.users_repository_arn
        ]
      },
      {
        Sid    = "ClusterPullPermissions"
        Effect = "Allow"
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchCheckLayerAvailability"
        ]
        Resource = var.users_repository_arn
      },
      {
        Sid    = "NoDeletes"
        Effect = "Deny"
        Action = [
          "ecr:BatchDeleteImage",
          "ecr:DeleteRepository",
          "ecr:DeleteRepositoryPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "walkai_api_task_role_policy_attachment" {
  role       = aws_iam_role.walkai_api_task_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

resource "aws_iam_policy" "cluster_cache_rw_policy" {
  name        = "put_and_delete_items_ddb_cluster_cache_table2"
  description = "Allow read/write access to the cluster_cache DynamoDB table."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ClusterCacheRW"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ]
        Resource = var.cluster_cache_table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_cache_rw_policy_attachment" {
  role       = aws_iam_role.walkai_api_task_role.name
  policy_arn = aws_iam_policy.cluster_cache_rw_policy.arn
}

resource "aws_iam_policy" "oauth_rw_policy" {
  name        = "put_and_delete_items_ddb_oauth_table2"
  description = "Allow write/delete access to the oauth DynamoDB table."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "OAuthTxRW"
        Effect = "Allow"
        Action = [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = var.oauth_table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "oauth_rw_policy_attachment" {
  role       = aws_iam_role.walkai_api_task_role.name
  policy_arn = aws_iam_policy.oauth_rw_policy.arn
}

resource "aws_iam_policy" "walkai_bucket_rw_policy" {
  name        = "put_objects_walkai_bucket2"
  description = "Allow ECS tasks to read/write objects in the info bucket."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowReadWriteObjectsInWalkai"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "${var.info_bucket_arn}/*"
      },
      {
        Sid      = "AllowListWalkaiBucket"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = replace(var.info_bucket_arn, "/*", "")
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "walkai_bucket_rw_policy_attachment" {
  role       = aws_iam_role.walkai_api_task_role.name
  policy_arn = aws_iam_policy.walkai_bucket_rw_policy.arn
}

resource "aws_iam_policy" "bootstrap_first_user_secret_get_policy" {
  name        = "secrets_manager_bootstrap_email2"
  description = "Allow get/describe the secret of the first user email."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowReadBootstrapSecret"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.bootstrap_first_user_secret_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bootstrap_first_user_secret_policy_attachment" {
  role       = aws_iam_role.walkai_api_task_role.name
  policy_arn = aws_iam_policy.bootstrap_first_user_secret_get_policy.arn
}

resource "aws_cloudwatch_log_group" "walkai_api_cloudwatch" {
  name              = "/ecs/walkai-api2"
  retention_in_days = 30
  tags              = var.tags
}

data "aws_region" "current" {}

resource "aws_ecs_task_definition" "walkai_api_task" {
  family                   = "walkai-api-task2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  task_role_arn            = aws_iam_role.walkai_api_task_role.arn

  container_definitions = jsonencode([
    {
      name      = local.api_container_name
      image     = var.repository_url
      essential = true
      environmentFiles = [
        {
          value = local.env_file_arn
          type  = "s3"
        }
      ]
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.walkai_api_cloudwatch.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = var.tags
}

resource "aws_ecs_service" "walkai_api_service" {
  name                 = "walkai-api-service2"
  cluster              = aws_ecs_cluster.walkai.id
  task_definition      = aws_ecs_task_definition.walkai_api_task.arn
  desired_count        = 1
  launch_type          = "FARGATE"
  scheduling_strategy  = "REPLICA"

  network_configuration {
    subnets          = [var.private_subnet_ids[0]]
    security_groups  = [aws_security_group.sg_ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = data.aws_lb_target_group.api.arn
    container_name   = local.api_container_name
    container_port   = 8000
  }

  tags = var.tags
}