terraform {
 required_providers {
  aws = {
   source = "hashicorp/aws"
   version = "~> 5.0"
 }
}

 backend "s3" {
   bucket = "devops-lab-tfstate-237575223274"
   key = "eks-cluster/terraform.tfstate"
   region = "us-east-1"
   use_lockfile = true
   encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
}

# EKS Cluster IAM Role
resource "aws_iam_role" "eks_cluster" {
 name = "devops-lab-eks-cluster-role"

 assume_role_policy = jsonencode({
   Version = "2012-10-17"
   Statement = [{
     Action = "sts:AssumeRole"
     Effect = "Allow"
     Principal = {
       Service = "eks.amazonaws.com"
    }
  }]
})

 tags = {
   Name = "devops-lab-eks-cluster-role"
   Environment = "lab"
   Owner = "mfrench"
  }
}

# Attach required policy to cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_cluster.name
}

# EKS Node IAM Role
resource "aws_iam_role" "eks_nodes" {
  name = "devops-lab-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "devops-lab-eks-node-role"
    Environment = "lab"
    Owner       = "mfrench"
  }
}

# Attach required policies to node role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}
