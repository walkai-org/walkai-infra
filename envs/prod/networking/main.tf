provider "aws" {
  region = var.region
}

module "networking" {
  source = "../../../modules/networking"

  name     = "walkai-prod-networking"
  vpc_cidr = var.vpc_cidr
  region   = var.region

  subnets = {
    public_a = {
      name                   = "walkai-public-subnet-a-az"
      cidr_block             = cidrsubnet(var.vpc_cidr, 2, 1)
      availability_zone      = "us-east-1a"
      public                 = true
      map_public_ip_on_launch = true
    }
    private_a = {
      name                 = "walkai-private-subnet-a-az"
      cidr_block           = cidrsubnet(var.vpc_cidr, 2, 0)
      availability_zone    = "us-east-1a"
      public               = false
    }
    public_b = {
      name                   = "walkai-public-subnet-b-az"
      cidr_block             = cidrsubnet(var.vpc_cidr, 2, 3)
      availability_zone      = "us-east-1b"
      public                 = true
      map_public_ip_on_launch = true
    }
    private_b = {
      name                 = "walkai-private-subnet-b-az"
      cidr_block           = cidrsubnet(var.vpc_cidr, 2, 2)
      availability_zone    = "us-east-1b"
      public               = false
    }
  }

  tags = {
    Environment = "prod"
    Project     = "walkai"
  }
}
