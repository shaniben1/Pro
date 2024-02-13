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


resource "aws_instance" "shani" {
  ami           = "0e731c8a588258d0d"
  instance_type = "t2.xlarge"

  tags = {
    Name = "ShaniInstance"
  }
}