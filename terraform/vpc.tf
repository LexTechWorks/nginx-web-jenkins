data "aws_vpc" "pipeline_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Pipeline - Project-vpc"]
  }
}

data "aws_subnets" "pipeline_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.pipeline_vpc.id]
  }
  
  filter {
    name   = "tag:Name"
    values = ["Pipeline - Project-subnet-public*"]
  }
}

data "aws_subnet" "pipeline_public_1a" {
  filter {
    name   = "tag:Name"
    values = ["Pipeline - Project-subnet-public1-us-east-1a"]
  }
}

data "aws_subnet" "pipeline_public_1b" {
  filter {
    name   = "tag:Name"
    values = ["Pipeline - Project-subnet-public2-us-east-1b"]
  }
}

data "aws_security_group" "pipeline_sg" {
  filter {
    name   = "group-name"
    values = ["SG-pipeline-project"]
  }
  vpc_id = data.aws_vpc.pipeline_vpc.id
}