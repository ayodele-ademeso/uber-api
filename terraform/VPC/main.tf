#Install provider and set remote backend
terraform {
  backend "s3" {
    bucket = "terraform-state-uberapp"
    key    = "eks-vpc.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

#Create VPC CIDR
resource "aws_vpc" "main" {
  cidr_block           = "192.168.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = {
    Name = "EKS-VPC"
  }
}

#Create 2 public and 2 private subnets
resource "aws_subnet" "public01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.0.0/18"
  availability_zone       = "us-east-1b"

  tags = {
    Name = "PublicSubnet01"
  }
}

resource "aws_subnet" "public02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.64.0/18"
  availability_zone       = "us-east-1d"

  tags = {
    Name = "PublicSubnet02"
  }
}

resource "aws_subnet" "private01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.128.0/18"
  availability_zone = "us-east-1c"

  tags = {
    Name = "PrivateSubnet01"
  }
}

resource "aws_subnet" "private02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.192.0/18"
  availability_zone = "us-east-1e"

  tags = {
    Name = "PrivateSubnet02"
  }
}

#Create 2 security groups

#Create IGW
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "EKS-VPC-GW"
  }
}
#Create NAT Gateway

#Create 2 Elastic IPs

#Create Route table
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "192.168.0.0/18"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    cidr_block = "192.168.64.0/18"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

