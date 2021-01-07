## Define providers

terraform {
  required_version = ">= 0.12.0"
}

provider "aws" {
  version = ">= 2.28.1"
  region  = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

#### Define data sources

terraform {
  backend "s3" {
    bucket = "checkout-bucket2021"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

# create the VPC using the official module

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "checkout-vpc"
  cidr = var.cidr

//  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
//  private_subnets = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
//  public_subnets  = ["10.100.101.0/24", "10.100.102.0/24", "10.100.103.0/24"]

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets


  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}


## Create the EKS cluster using official module

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "checkout-eks"
  cluster_version = "1.16"
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  worker_groups = [
    {
      instance_type = "t2.small"
      asg_max_size  = 3
      asg_desired_size = 2
    }
  ]
}


