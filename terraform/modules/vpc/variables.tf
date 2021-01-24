variable "project" {
  description = "project name"
  default     =  "checkout"
}

variable "cidr" {
  description = "The CIDR block"
}

variable "instance_tenancy" {
  description = "A tenancy option for instances launched into the VPC"
  default     = "default"
}

variable "public_subnets" {
  type = list
  description = "A list of public subnets inside the VPC"
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type = list
}


variable "azs" {
  type = list
  description = "A list of availability zones in the region"
  default = ["eu-west-1a","eu-west-1b","eu-west-1c"]
}

variable "enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Should be false if you do not want to auto-assign public IP on launch"
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}

variable "vpc_tags" {
  description = "Additional tags for the VPC"
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the admin subnets"
  default     = {}
}
