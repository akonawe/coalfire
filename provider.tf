terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.47.0"
    }
  }
}

provider "aws" {
 region = var.AWS_Region
 access_key = var.AWS_ACCESS_KEY
 secret_key = var.AWS_secret_key
}
