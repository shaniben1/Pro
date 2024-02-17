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

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
      token = var.token
    }


  }

  required_version = "~> 1.0"
}

provider "aws" {
  region = "us-east-1"
}
