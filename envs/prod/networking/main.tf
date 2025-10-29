provider "aws" {
  region = var.region
}

module "networking" {
  source = "../../../modules/networking"

  name                = "walkai-prod-networking"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  public_subnet_az    = "us-east-1a"
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet_az   = "us-east-1b"

  tags = {
    Environment = "prod"
    Project     = "walkai"
  }
}
