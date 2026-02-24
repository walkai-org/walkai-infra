terraform {
  backend "s3" {
    key     = "prod/web_distribution/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
