output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of ID public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of ID for private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID Internet Gateway"
  value       = aws_internet_gateway.igw.id
}