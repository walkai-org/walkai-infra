terraform {
  backend "s3" {
    key            = "prod/networking/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
