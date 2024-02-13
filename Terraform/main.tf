terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.36.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}
