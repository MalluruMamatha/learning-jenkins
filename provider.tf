terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.56.1"
    }
  }
    backend "s3" {
    bucket = "expense-devops"
    key    = "learning-jenkins"
    region = "us-east-1"
    dynamodb_table = "expense-devops-lock"
  }
}


provider "aws" {
    region = "us-east-1"
  # Configuration options
}