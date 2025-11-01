provider "aws" {
  region = var.region
}

module "networking" {
  source = "../../../modules/networking"

  name     = "walkai-prod-networking"
  vpc_cidr = "172.31.0.0/16"

  subnets = {
    public_a = {
      name                   = "walkai-public-subnet-a-az"
      cidr_block             = "172.31.96.0/20"
      availability_zone      = "us-east-1a"
      public                 = true
      map_public_ip_on_launch = true
    }
    private_a = {
      name                 = "walkai-private-subnet-a-az"
      cidr_block           = "172.31.0.0/20"
      availability_zone    = "us-east-1a"
      public               = false
    }
    public_b = {
      name                   = "walkai-public-subnet-b-az"
      cidr_block             = "172.31.112.0/20"
      availability_zone      = "us-east-1b"
      public                 = true
      map_public_ip_on_launch = true
    }
    private_b = {
      name                 = "walkai-private-subnet-b-az"
      cidr_block           = "172.31.80.0/20"
      availability_zone    = "us-east-1b"
      public               = false
    }
  }

  tags = {
    Environment = "prod"
    Project     = "walkai"
  }
}
