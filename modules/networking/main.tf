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
  first_public_subnet_key = try(local.public_subnet_keys[0], null)
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

resource "aws_default_route_table" "private" {
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

resource "aws_main_route_table_association" "public_main" {
  vpc_id         = aws_vpc.this.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "walkai-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "public" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnets[local.first_public_subnet_key].id

  tags = merge(
    var.tags,
    {
      Name = "walkai-nat-gateway2"
    }
  )
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.this.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_default_route_table.private.id]

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

  route_table_ids = [aws_default_route_table.private.id]

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
  route_table_id = aws_default_route_table.private.id
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_default_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public.id
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

resource "aws_network_acl" "this" {
  vpc_id = aws_vpc.this.id

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-acl"
    }
  )
}

resource "aws_network_acl_association" "subnets" {
  for_each      = aws_subnet.subnets
  network_acl_id = aws_network_acl.this.id
  subnet_id      = each.value.id
}
