locals {
  max_subnet_length = max(length(var.public_subnets), length(var.private_subnets))
}

variable "aws_region" {
  default = "eu-west-1"
}

locals {
  nat_gateway_count = length(var.private_subnets)
}


resource "aws_eip" "nat_gw" {
  count = local.nat_gateway_count > 0 ? local.nat_gateway_count : 0
  vpc = true
}


######
# VPC
######
resource "aws_vpc" "this" {

  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
//  tags = var.vpc_tags
    tags = merge(var.tags, var.vpc_tags, map("Name", format("%s-vpc", var.project)))
}


###################
# Internet Gateway
###################
resource "aws_internet_gateway" "this" {
//  count = length(var.public_subnets) > 0 ? 1 : 0
  vpc_id = aws_vpc.this.id

}

################
# Publiс routes
################
resource "aws_route_table" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id = aws_vpc.this.id

}

resource "aws_route" "public_internet_gateway" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

#################
# Private routes
#################
resource "aws_route_table" "private" {
  count = local.max_subnet_length > 0 ? local.max_subnet_length : 0

  vpc_id = aws_vpc.this.id
}

####################
# Public subnet
####################
resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = var.map_public_ip_on_launch
//  tags = var.public_subnet_tags
  tags = merge(var.tags, var.public_subnet_tags, map("Name", format("%s-public-subnet", var.project)))
}


######################
# Private subnet
######################
resource "aws_subnet" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(var.azs, count.index)
//  tags = var.private_subnet_tags
  tags = merge(var.tags, var.public_subnet_tags, map("Name", format("%s-private-subnet", var.project)))

}


######################
# Natgateway
######################

locals {
  nat_gateway_ips = [aws_eip.nat_gw.*.id]
}

resource "aws_nat_gateway" "this" {
  count = length(var.private_subnets)

  allocation_id = element(aws_eip.nat_gw.*.id,count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on = [aws_internet_gateway.this]
}


resource "aws_route" "admin_nat_gateway" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.this.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

##########################
# Route table association
##########################
resource "aws_route_table_association" "private" {
  count = length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)

}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}
