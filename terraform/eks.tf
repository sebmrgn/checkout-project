#### Define data sources

//data "aws_eks_cluster" "cluster" {
//  name = module.eks.cluster_id
//}
//
//data "aws_eks_cluster_auth" "cluster" {
//  name = module.eks.cluster_id
//}
//
//## Create the EKS cluster using official module
//
//module "eks" {
//  source          = "terraform-aws-modules/eks/aws"
//  cluster_name    = var.cluster_name
//  cluster_version = "1.18"
//  subnets         = module.vpc.private_subnets
//  vpc_id          = module.vpc.vpc_id
//
//  worker_groups = [
//    {
//      instance_type = "t2.small"
//      asg_max_size  = 3
//      asg_min_size = 2
//    }
//  ]
//}

### Use internal module for EKS cluster


module "eks" {
  source = "./modules/eks"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id

  instance_type = ["t2.small"]
  asg_max_size  = 2
  asg_min_size = 2
  asg_desired_size = 2
}


