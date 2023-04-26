terraform {
  required_version = "~> 1.3.9"
  backend "s3" {
    bucket         = "S3_BUCKET_NAME"
    key            = "terraform.state"
    region         = "AWS_REGION"
    dynamodb_table = "DYNAMODB_TABLE_NAME"
  }

  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

provider "aws" {
  region = "AWS_REGION"
}

provider "sops" {}
