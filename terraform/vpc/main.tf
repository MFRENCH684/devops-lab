terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
   version = "~> 5.0"
  }
 }
}

provider "aws" {
 region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "devops-lab-vpc"
    Environment = "lab"
    Owner = "mfrench"
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-lab-public"
    Environment = "lab"
    Owner = "mfrench"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "devops-lab-private"
    Environment = "lab"
    Owner = "mfrench"
  }
}
