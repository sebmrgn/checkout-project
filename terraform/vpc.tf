# create the VPC using the official module

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "checkout-vpc"
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets


  enable_nat_gateway = true
  enable_vpn_gateway = true
  enable_dns_support = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
    "kubernetes.io/cluster/checkout-eks" = "shared"
  }
}
