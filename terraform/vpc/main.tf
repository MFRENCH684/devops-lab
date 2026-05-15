terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
   version = "~> 5.0"
  }
 }

 backend "s3" {
   bucket = "devops-lab-tfstate-237575223274"
   key = "vpc/terraform.tfstate"
   region = "us-east-1"
   use_lockfile = true
   encrypt = true
  }
 }

provider "aws" {
 region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "devops-lab-vpc"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "devops-lab-public"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-east-1b"

  tags = {
    Name = "devops-lab-private"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "devops-lab-igw"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "devops-lab-public-rt"
    Environment = var.environment
    Owner = var.owner
  
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


