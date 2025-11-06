terraform {
  backend "s3" {
    bucket = "walkai-terraform-state"
    key    = "prod/storage/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
