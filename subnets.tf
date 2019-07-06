resource "aws_subnet" "bastion" {
  tags = {
    Name = "subnet_bastion"
    Tier = "Bastion"
  }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_bastion_cidr
  availability_zone = var.az
}

data "aws_vpc" "vpc" {
  id = aws_vpc.vpc.id
}

data "aws_subnet_ids" "bastion" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Tier = "Bastion"
  }
}

resource "aws_subnet" "public" {
  tags = {
    Name = "subnet_public"
  }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_public_cidr
  availability_zone = var.az
}

resource "aws_subnet" "private" {
  tags = {
    Name = "subnet_private"
  }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_private_cidr
  availability_zone = var.az
}

resource "aws_subnet" "nat" {
  tags = {
    Name = "subnet_nat"
  }

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.subnet_nat_cidr
  availability_zone = var.az
}
