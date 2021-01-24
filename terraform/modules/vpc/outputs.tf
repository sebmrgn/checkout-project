# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "private_subnet_ids" {
  description = "Private subnet list"
  value       = aws_subnet.private.*.id
}
