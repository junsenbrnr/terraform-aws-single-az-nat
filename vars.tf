# variables to use within templates
variable "region" {
    description = "The region where we're building awesome stuff."
    default = "us-east-1"
}

variable "vpc_name" {
    description = "The name to use for the VPC"
    default = "terraform_vpc_test"
}

variable "vpc_cidr" {
    description = "The base CIDR to use when creating the vpc, custom route table, etc."
    default = "10.0.0.0/16"
}

# bastion subnet vars
variable "subnet_bastion_cidr" {
    description = "Bastion subnet"
    default = "10.0.0.0/24"
}

variable "subnet_bastion_az" {
    description = "The availability zone of subnet_bastion"
    default = "us-east-1a"
}

# public subnet vars
variable "subnet_public_cidr" {
    description = "Public subnet"
    default = "10.0.1.0/24"
}

variable "subnet_public_az" {
    description = "The availability zone of subnet_public"
    default = "us-east-1a"
}

# private subnet vars
variable "subnet_private_cidr" {
    description = "Private subnet"
    default = "10.0.3.0/24"
}

variable "subnet_private_az" {
    description = "The availability zone of subnet_private"
    default = "us-east-1a"
}

# nat subnet vars
variable "subnet_nat_cidr" {
    description = "NAT subnet"
    default = "10.0.2.0/24"
}

variable "subnet_nat_az" {
    description = "The availability zone of subnet_nat"
    default = "us-east-1a"
}

variable "instance_type" {
    description = "FREE TIER: Use t2.micro."
    default = "t2.micro"
}

variable "base_ami_id" {
    description = "The base AWS Linux AMI id."
    default = "ami-0de53d8956e8dcf80"
}

variable "nat_ami_id" {
    description = "NAT AWS Linux AMI id."
    default = "ami-00a9d4a05375b2763"
}

variable "known_cidrs" {
    description = "A list of known CIDRs"
    default = [
        "YOUR.IP.HERE/32",
    ]
}

variable "bastion_key_name" {
    description = "Key name which to associate the basion instances"
    default = "YOUR_KEY_HERE"
}

variable "public_key_name" {
    description = "Key name which to associate the public instances"
    default = "YOUR_KEY_HERE"
}

variable "nat_key_name" {
    description = "Key name which to associate the nat instances"
    default = "YOUR_KEY_HERE"
}

variable "private_key_name" {
    description = "Key name which to associate the private instances"
    default = "YOUR_KEY_HERE"
}