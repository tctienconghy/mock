terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.9.0"
    }
  } 
}

provider "aws" {
  access_key = var.my_access_key
  secret_key = var.my_secret_key
  region     = "us-east-1"
}