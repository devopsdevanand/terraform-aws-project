terraform {
  required_version = ">= 1.4.0"

  backend "s3" {
    bucket         = "deva-terraform-remote-s3"   # pre-created manually
    key            = "global/s3-ec2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.0"
    }
  }
}

