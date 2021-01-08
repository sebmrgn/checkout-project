variable "region" {
  default = "eu-west-1"
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnets"
}

variable "azs" {
  type        = list(string)
  description = "List of some azs"
}

variable "cidr" {
  type        = string
  description = "CIDR to use"
}

variable "cluster_name" {
  type = string
  description = "Cluster name"
}