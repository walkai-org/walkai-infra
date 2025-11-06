terraform {
  backend "s3" {
    bucket         = "walkai-terraform-state"
    key            = "prod/networking/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "walkai-terraform-locks"
    encrypt        = true
  }
}
