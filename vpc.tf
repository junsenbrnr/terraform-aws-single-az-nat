terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region  = "us-east-1"
  version = "2.18.0"

  ################################################################################
  # by default your aws credentials are stored in $HOME/.aws/credentials. if it is
  # different copy terraform.tfvars.example to terraform.tfvars, uncomment the
  # variable, set the path to your credentials file, and uncomment the variable
  # below. terraform.tfvars is excluded from version control
  # 
  # shared_credentials_file = "/path/to/.aws/credentials"
  # 
  # by default the profile is "default". if you have multiple profiles and need
  # to use a specific one copy terraform.tfvars.example to terraform.tfvars,
  # uncomment the variable, set the profile name, and uncomment the variable
  # below
  # 
  # need to set up another profile? run: aws configure --profile new-profile-name
  # 
  # profile = "other-profile"
}

# create the vpc
resource "aws_vpc" "vpc" {
  tags = {
    Name = var.vpc_name
  }

  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# create the igw
resource "aws_internet_gateway" "igw" {
  tags = {
    Name = "igw_vpc_test"
  }

  vpc_id = aws_vpc.vpc.id
}
