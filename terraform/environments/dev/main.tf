terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    tls = {
      source = "hashicorp/tls"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "network" {
  source = "../../modules/network"

  environment = "dev"
  vpc_cidr    = "10.0.0.0/16"
}

module "eks" {
  source = "../../modules/eks"

  environment  = "dev"
  cluster_name = "dev-eks"

  vpc_id = module.network.vpc_id

  private_subnet_ids = module.network.private_subnet_ids
}

module "ecr" {
  source = "../../modules/ecr"

  environment     = "dev"
  repository_name = "dev-ai-api"
}

output "repository_url" {
  value = module.ecr.repository_url
}