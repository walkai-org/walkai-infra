provider "aws" {
  region = var.region
}

module "storage" {
  source = "../../../modules/storage"

  table_name        = "walkai_cluster_cache"
  oauth_table_name  = "walkai_oauth_tx"
  bucket_name       = "walkaiorg.app-client"
  info_bucket_name  = "walkai-info2"

  tags = {
    Environment = "prod"
    Project     = "walkai"
  }
}
