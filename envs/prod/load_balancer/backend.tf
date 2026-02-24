terraform {
  backend "s3" {
    key     = "prod/load_balancer/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
