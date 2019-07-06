# variables to use within templates
variable "region" {
  description = "The region where we're building awesome stuff"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name to use for the VPC"
  type        = string
  default     = "terraform_vpc"
}

variable "vpc_cidr" {
  description = "The base CIDR to use when creating the vpc, custom route table, etc."
  type        = string
  default     = "10.0.0.0/16"
}

variable "az" {
  description = "The availability zone"
  type        = string
  default     = "us-east-1a"
}

# bastion subnet vars
variable "subnet_bastion_cidr" {
  description = "Bastion subnet"
  type        = string
  default     = "10.0.0.0/24"
}

# public subnet vars
variable "subnet_public_cidr" {
  description = "Public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# private subnet vars
variable "subnet_private_cidr" {
  description = "Private subnet"
  type        = string
  default     = "10.0.3.0/24"
}

# nat subnet vars
variable "subnet_nat_cidr" {
  description = "NAT subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "FREE TIER: Use t2.micro"
  type        = string
  default     = "t2.micro"
}

variable "base_ami_id" {
  description = "The base AWS Linux AMI id"
  type        = string
  default     = "ami-0de53d8956e8dcf80"
}

variable "nat_ami_id" {
  description = "NAT AWS Linux AMI id"
  type        = string
  default     = "ami-00a9d4a05375b2763"
}

variable "known_cidrs" {
  description = "A list of known CIDRs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "key_name" {
  description = "Key name to connect to your instances"
  default     = "YOUR_KEY_HERE"
}
