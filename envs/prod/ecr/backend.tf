terraform {
  backend "s3" {
    key     = "prod/ecr/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
