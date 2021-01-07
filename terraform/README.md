Deploy a quick and simple AWS EKS cluster with Terraform v0.12 

## Resources

1. VPC
2. Internet Gateway (IGW)
3. Public / Private Subnets
4. Security Groups, Route Tables and Route Table Associations
5. IAM roles, instance profiles and policies
6. EKS Cluster
7. Autoscaling group and Launch Configuration
8. Worker Nodes in a private Subnet

## Configuration

| Name                      | Description                        | Default                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------- | ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `cluster-name`            | The name of your EKS Cluster       | `simple-eks`                                                                                                                                                                                                                                                                                                                                                                                                    |
| `aws-region`              | The AWS Region to deploy EKS       | `eu-west-1`                                                                                                                                                                                                                                                                                                                                                                                                      |
| `availability-zones`      | AWS Availability Zones             | `["eu-west-1a", "eu-west-1b", "eu-west-1c"]`                                                                                                                                                                                                                                                                                                                                                                     |
| `k8s-version`             | The desired K8s version to launch  | `1.16`                                                                                                                                                                                                                                                                                                                                                                                                           |
| `instance_type`           | Worker Node EC2 instance type      | `t2.small`                                                                                                                                                                                                                                                                                                                                                                                                       |
| `asg_max_size`            | Autoscaling Maximum node capacity  | `3`                                                                                                                                                                                                                                                                                                                                                                                                              |
| `vpc-subnet-cidr`         | Subnet CIDR                        | `10.100.0.0/16`                                                                                                                                                                                                                                                                                                                                                                                                    |
| `private-subnet-cidr`     | Private Subnet CIDR                | `["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]`                                                                                                                                                                                                                                                                                                                                                                |
| `public-subnet-cidr`      | Public Subnet CIDR                 | `["10.100.101.0/24", "10.100.102.0/24", "10.100.103.0/24"]`


### Terraform

You need to run the following commands to create the resources with Terraform:

```bash
terraform init
terraform plan
terraform apply
```

### Setup kubectl

Setup your `KUBECONFIG`

```bash
terraform output kubectl_config > ~/.kube/eks-cluster
export KUBECONFIG=~/.kube/eks-cluster
```

You can verify the worker nodes are joining the cluster

```bash
kubectl get nodes --watch
```

### Cleaning up

You can destroy this cluster entirely by running:

```bash
terraform plan -destroy
terraform destroy  --force
```