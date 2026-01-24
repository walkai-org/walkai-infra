provider "aws" {
  region = var.region
}

data "terraform_remote_state" "networking" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/networking/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

data "terraform_remote_state" "load_balancer" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/load_balancer/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

data "terraform_remote_state" "storage" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/storage/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"

  config = {
    bucket  = "walkai-terraform-state"
    key     = "prod/ecr/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

module "ecs" {
  source = "../../../modules/ecs"

  repository_name       = data.terraform_remote_state.ecr.outputs.repository_name
  repository_url        = data.terraform_remote_state.ecr.outputs.repository_url
  users_repository_arn  = data.terraform_remote_state.ecr.outputs.users_repository_arn
  tags                  = var.tags
  vpc_id                = data.terraform_remote_state.networking.outputs.vpc_id
  alb_security_group_id = data.terraform_remote_state.load_balancer.outputs.alb_security_group_id
  alb_target_group_arn  = data.terraform_remote_state.load_balancer.outputs.alb_target_group_arn
  private_subnet_ids    = [
    data.terraform_remote_state.networking.outputs.subnet_ids["private_a"],
    data.terraform_remote_state.networking.outputs.subnet_ids["private_b"]
  ]
  info_bucket_arn         = data.terraform_remote_state.storage.outputs.info_bucket_arn
  cluster_cache_table_arn = data.terraform_remote_state.storage.outputs.cluster_cache_table_arn
  oauth_table_arn         = data.terraform_remote_state.storage.outputs.oauth_table_arn

  depends_on = [
    data.terraform_remote_state.networking,
    data.terraform_remote_state.load_balancer,
    data.terraform_remote_state.storage,
    data.terraform_remote_state.ecr
  ]
}
