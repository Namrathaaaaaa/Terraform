terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.79.0"
    }
  }
  backend "s3" {
    bucket         = "my-tws-bucket-namratha"
    key            = "terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tws-state-table"
  }
}
