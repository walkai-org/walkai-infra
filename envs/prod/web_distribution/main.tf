provider "aws" {
  region = var.region
}

module "web_distribution" {
  source = "../../../modules/web_distribution"

  app_client_bucket_name = var.app_client_bucket_name
  tags                   = var.tags

  depends_on = [
    module.storage
  ]
}
