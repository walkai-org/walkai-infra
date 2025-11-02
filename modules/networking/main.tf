resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

locals {
  public_subnet_keys  = [for key, subnet in var.subnets : key if subnet.public]
  private_subnet_keys = [for key, subnet in var.subnets : key if !subnet.public]
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-igw"
    }
  )
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id

  tags = merge(
    var.tags,
    {
      Name = "private-rtb"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(
    var.tags,
    {
      Name = "public-rtb"
    }
  )
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_default_route_table.this.id]

  tags = merge(
    var.tags,
    {
      Name = "ecs-private-tasks-s3-gateway"
    }
  )
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_default_route_table.this.id]

  tags = merge(
    var.tags,
    {
      Name = "ecs-private-tasks-dynamodb-gateway"
    }
  )
}

resource "aws_route_table_association" "public" {
  for_each       = toset(local.public_subnet_keys)
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = toset(local.private_subnet_keys)
  subnet_id      = aws_subnet.subnets[each.key].id
  route_table_id = aws_default_route_table.this.id
}

resource "aws_subnet" "subnets" {
  for_each = var.subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = try(each.value.map_public_ip_on_launch, each.value.public)

  tags = merge(
    var.tags,
    {
      Name = each.value.name
      Tier = each.value.public ? "public" : "private"
    }
  )
}
