# Terraform Provider Configuration
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = "nginx-web-site"
      Environment = var.environment
      ManagedBy   = "terraform"
      Owner       = "LexTechWorks"
    }
  }
}