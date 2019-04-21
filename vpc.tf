provider "aws" {
    region = "${var.region}"
    # if you have multiple aws profiles uncomment
    # the two lines below
    # 
    # shared_credentials_file = "/path/to/.aws/credentials"
    # profile = "profile_name"
}

# create the vpc
resource "aws_vpc" "vpc" {
  tags {
    Name = "terraform_vpc_test"
  }

  cidr_block = "${var.vpc_cidr}"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# create the igw
resource "aws_internet_gateway" "igw" {
  tags {
    Name = "igw_vpc_test"
  }

  vpc_id = "${aws_vpc.vpc.id}"
}
