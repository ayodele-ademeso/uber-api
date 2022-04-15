terraform {
  backend "s3" {
    bucket = "terraform-state-uberapp"
    key    = "ecr-terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "uberapp-ecr-repo" {
  name                 = "uber_app"
  image_tag_mutability = "MUTABLE"
}