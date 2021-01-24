variable "cluster_name" {
  type        = string
  description = "Cluster name"
  default     = "checkout-eks"
}

variable "private_subnet_ids" {
  description = "A list of private subnet ids "
  type        = list
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.small"
}

variable "asg_max_size" {
  description = "Max size of AG"
  default     = 1
}

variable "asg_min_size" {
  description = "Min size of AG"
  default     = 1
}

variable "asg_desired_size" {
  description = "Desired size of AG"
  default     = 1
}
