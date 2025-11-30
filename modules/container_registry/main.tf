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


locals {
  api_container_name = replace(var.repository_name, "/", "-")
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

  container_definitions = jsonencode([
    {
      name      = local.api_container_name
      image     = aws_ecr_repository.api.repository_url
      essential = true
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
  name            = "walkai-api-service2"
  cluster         = aws_ecs_cluster.walkai.id
  task_definition = aws_ecs_task_definition.walkai_api_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  scheduling_strategy = "REPLICA"

  network_configuration {
    subnets         = [var.private_subnet_ids[0]]
    security_groups = [aws_security_group.sg_ecs.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = local.api_container_name
    container_port   = 8000
  }

  tags = var.tags
}
