# create the VPC using the official module

//module "vpc" {
//  source = "terraform-aws-modules/vpc/aws"
//
//  name = "checkout-vpc"
//  cidr = var.cidr
//
//  azs             = var.azs
//  private_subnets = var.private_subnets
//  public_subnets  = var.public_subnets
//
//
//  enable_nat_gateway = true
//  enable_vpn_gateway = true
//  enable_dns_support = true
//  enable_dns_hostnames = true
//
//  public_subnet_tags = {
//    "kubernetes.io/role/elb" = "1"
//  }
//
//  private_subnet_tags = {
//    "kubernetes.io/role/internal-elb" = "1"
//  }
//
//  tags = {
//    Terraform = "true"
//    Environment = "dev"
//    "kubernetes.io/cluster/checkout-eks" = "shared"
//  }
//}


### Using local module

module "vpc" {
  source = "./modules/vpc"

  private_subnets = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  public_subnets  = ["10.100.101.0/24", "10.100.102.0/24", "10.100.103.0/24"]
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cidr            = "10.100.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  vpc_tags = {
    Terraform = "true"
    Environment = "dev"
    "kubernetes.io/cluster/checkout-eks" = "shared"
  }

  tags = {
    project = "checkout"
  }
}
