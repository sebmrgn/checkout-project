variable "region" {
  default = "eu-west-1"
}

variable "private_subnets" {
  type        = list(string)
  description = "A list of private subnets"
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
}

variable "public_subnets" {
  type        = list(string)
  description = "A list of public subnets"
  default     = ["10.100.101.0/24", "10.100.102.0/24", "10.100.103.0/24"]
}

variable "azs" {
  type        = list(string)
  description = "List of some azs"
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "cidr" {
  type        = string
  description = "CIDR to use"
  default     = "10.100.0.0/16"
}

variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "checkout-eks"
}