terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.47.0"
    }
  }
}

backend "s3" {
  bucket = "ordering-systems3"
  key    = "lambda-authorizers/terraform.tfstate"
  região = var.aws_region
}


provider "aws" {
  region = var.aws_region
}