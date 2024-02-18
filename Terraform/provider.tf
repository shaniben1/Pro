terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }

    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }

 }

   required_version = "~> 1.0"
}


provider "aws" {
  region = "us-east-1"
}


provider "github" {
  github_token = var.token
}


