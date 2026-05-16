variable "aws_region" {
 description = "AWS region"
 type = string
 default = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type = string
  default = "devops-lab-eks"
}

variable "vpc_id" {
  description = "VPC ID for EKS cluster"
  type = string
  default = "vpc-04a663042e94f2eb"
}

variable "public_subnet_id" {
  description = "Public subnet ID"
  type = string
  default = "subnet-0f307d21a45507883"
}

variable "private_subnet_id" {
  description = "Private subnet ID"
  type = string
  default = "subnet-0f8e6b5f0fabdc90d"
}
