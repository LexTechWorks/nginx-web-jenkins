terraform {
  backend "s3" {
    bucket  = "lextechworks"
    key     = "aws-nginx-site/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
  
  required_version = ">= 1.0"
}