######################
### EKS CLUSTER ######
######################

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks-role.arn

  vpc_config {
    subnet_ids= var.private_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.checkout-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.checkout-AmazonEKSVPCResourceController,
  ]
}

########################
### EKS NodeGroup ######
########################

resource "aws_eks_node_group" "checkout-ng" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "checkout-nodegroup"
  node_role_arn   = aws_iam_role.checkout-nodegroup-role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types = var.instance_type

  scaling_config {
    max_size     = var.asg_max_size
    min_size     = var.asg_min_size
    desired_size = var.asg_desired_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.checkout-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.checkout-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.checkout-AmazonEC2ContainerRegistryReadOnly,
  ]
}

