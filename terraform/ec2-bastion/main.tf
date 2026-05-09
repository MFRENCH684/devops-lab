terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Upload public key to AWS
resource "aws_key_pair" "bastion" {
  key_name = "devops-lab-bastion"
  public_key = file("~/.ssh/devops-lab-bastion.pub")
}

resource "aws_security_group" "bastion" {
  name = "devops-lab-bastion-sg"
  description = "Security group for bastion host"
  vpc_id = "vpc-04a6630424e94f2eb"

ingress {
  description = "SSH from anywhere"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

egress {
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

tags = {
  Name = "devops-lab-bastion-sg"
  Environment = "lab"
  Owner = "mfrench"
 }
}

resource "aws_instance" "bastion" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  subnet_id = "subnet-0f307d21a45507883"
  key_name = aws_key_pair.bastion.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]
  associate_public_ip_address = true

  tags = {
    Name = "devops-lab-bastion"
    Environment =  "lab"
    Owner = "mfrench"
  }
}
