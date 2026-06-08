terraform {
  required_version = "~> 1.11"

  backend "s3" {
    bucket  = "datafy-terraform-state-training"
    key     = "agent-skills-workshop.tfstate"
    region  = "eu-west-1"
    profile = "demo"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    conveyor = {
      source  = "datamindedbe/conveyor"
      version = "~> 0.7.0"
    }
  }
}

provider "aws" {
  region              = var.aws_region
  allowed_account_ids = [var.aws_account_id]
  profile             = "demo"
}
