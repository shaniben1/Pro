terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }

  }

  required_version = "~> 1.0"
}
module "apigateway-v2" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "3.1.0"
}
provider "aws" {
  region = "us-east-1"
}
