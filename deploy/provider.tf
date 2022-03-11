terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.4.0"
    }
  }
  backend "s3" {
    bucket = "cuvalley"
    key    = "states"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}