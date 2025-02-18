terraform {
  backend "s3" {
    bucket = "terraform-20250212151906931400000001"
    key    = "PET_tfstate/terraform.tfstate"
    region = "eu-central-1"
    dynamodb_table = "tfstate_locking"
    encrypt        = true
  }

  required_providers {
    aws = {
    source  = "hashicorp/aws"
    version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "database" {
  source = "../modules/database"
}