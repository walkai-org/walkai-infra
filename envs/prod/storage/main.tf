provider "aws" {
  region = var.region
}

module "storage" {
  source = "../../../modules/storage"

  table_name  = "walkai_cluster_cache"
  bucket_name = "walkaiorg.app-client"
  tags = {
    Environment = "prod"
    Project     = "walkai"
  }
}
