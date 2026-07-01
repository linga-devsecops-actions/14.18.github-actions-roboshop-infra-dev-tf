terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.95"
    }
  }
backend "s3" {
  bucket = "linga-devops-rs"
    key    = "roboshop-infra-dev-actions-eks"
    region = "us-east-1"
    #dynamodb_table = "roboshop13-locking"
    use_lockfile = true
  }
}
provider "aws" {
  # Configuration options
  region = "us-east-1"
}