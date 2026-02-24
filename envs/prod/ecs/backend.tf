terraform {
  backend "s3" {
    key     = "prod/ecs/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
