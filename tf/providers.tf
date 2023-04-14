terraform {
  backend "s3" {
    bucket         = "chainlink-article-terraform"
    key            = "terraform.state"
    region         = "us-east-1"
    dynamodb_table = "chainlink-article-terraform-lock"
  }

  required_providers {
    sops = {
      source  = "carlpett/sops"
      version = "~> 0.5"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "sops" {}
