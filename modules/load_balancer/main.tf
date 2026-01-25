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

data "aws_lb_listeners" "existing" {
  load_balancer_arn = aws_lb.walkai_api_alb.arn
}

data "aws_lb_listener" "existing" {
  for_each = toset(data.aws_lb_listeners.existing.arns)
  arn      = each.value
}

locals {
  web_domain = "walkai.${var.base_domain}"
  api_domain = "api.walkai.${var.base_domain}"
  hosted_zone_domain = var.external_dns ? local.web_domain : var.base_domain
}

resource "aws_route53_zone" "primary" {
  name          = local.hosted_zone_domain
  force_destroy = true

  tags = merge(
    var.tags,
    {
      Name = "walkai-base-zone"
    }
  )
}

locals {
  hosted_zone_id = aws_route53_zone.primary.zone_id
  name_servers   = aws_route53_zone.primary.name_servers
}

resource "aws_acm_certificate" "primary" {
  domain_name               = local.web_domain
  subject_alternative_names = [local.api_domain]
  validation_method         = "DNS"

  tags = merge(
    var.tags,
    {
      Name = "walkai-walkai-cert"
    }
  )
}

locals {
  acm_validation_records = {
    for dvo in aws_acm_certificate.primary.domain_validation_options :
    dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  alb_certificate_arn = coalesce(var.alb_acm_certificate_arn, aws_acm_certificate.primary.arn)
  https_enabled       = var.enable_https
  existing_https_listener = length([
    for listener in data.aws_lb_listener.existing :
    listener.port if listener.port == 443
  ]) > 0
}

resource "aws_route53_record" "acm_validation" {
  for_each = local.acm_validation_records

  zone_id = local.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

resource "aws_acm_certificate_validation" "primary" {
  count = local.https_enabled ? 1 : 0

  certificate_arn         = aws_acm_certificate.primary.arn
  validation_record_fqdns = [for record in aws_route53_record.acm_validation : record.fqdn]
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

resource "aws_lb_listener" "http_80_redirect" {
  count = local.https_enabled ? 1 : 0

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
resource "aws_lb_listener" "http_80_forward" {
  count = local.https_enabled ? 0 : 1

  load_balancer_arn = aws_lb.walkai_api_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_ecs_tg.arn
  }
}

resource "aws_lb_listener" "https_443" {
  count = local.https_enabled && !local.existing_https_listener ? 1 : 0

  load_balancer_arn = aws_lb.walkai_api_alb.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = var.ssl_policy
  certificate_arn = local.alb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_ecs_tg.arn
  }

  depends_on = [
    aws_acm_certificate_validation.primary
  ]
}

resource "aws_route53_record" "alb_api" {
  zone_id = local.hosted_zone_id
  name    = local.api_domain
  type    = "A"

  alias {
    name                   = aws_lb.walkai_api_alb.dns_name
    zone_id                = aws_lb.walkai_api_alb.zone_id
    evaluate_target_health = false
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
