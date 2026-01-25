resource "aws_lb" "walkai_api_alb" {
  name               = "walkai-api-alb-terraform"
  load_balancer_type = "application"
  internal           = false
  ip_address_type    = "ipv4"

  security_groups = [
    aws_security_group.alb.id,
  ]

  subnets = var.public_subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "walkai-api-alb"
    }
  )
}

resource "aws_lb_target_group" "api_ecs_tg" {
  name = "api-ecs-terraform"
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  port        = 8000
  target_type = "ip"                        # TODO: change to "instance" if that’s what you use

  health_check {
    enabled             = true
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200-399"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    interval            = 30
    timeout             = 5
  }

  tags = merge(
    var.tags,
    {
      Name = "api-ecs-tg"
    }
  )
}

resource "aws_lb_listener" "http_80" {
  load_balancer_arn = aws_lb.walkai_api_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      host        = "#{host}"
      path        = "/#{path}"
      query       = "#{query}"
      status_code = "HTTP_301"
    }
  }
}
resource "aws_lb_listener" "https_443" {
  load_balancer_arn = aws_lb.walkai_api_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = var.alb_acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_ecs_tg.arn
  }
}



resource "aws_security_group" "alb" {
  name        = "sg_alb"
  description = "Allows alb communication"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "sg_alb_terraform"
    }
  )
}
