terraform {
  required_version = "~> 1.11"

  backend "s3" {
    bucket  = "rainman-terraform-state-snjgwg"
    key     = "hackathon.tfstate"
    region  = "eu-west-1"
    profile = "rainman"
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
  profile             = "rainman"
}
