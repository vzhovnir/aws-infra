output "private_subnet-a" {
  value       = aws_subnet.private_subnets[0].id
  description = "The private IP address of the main server instance."
}

output "private_subnet-b" {
  value       = aws_subnet.private_subnets[1].id
  description = "The private IP address of the main server instance."
}

output "private_subnet-c" {
  value       = aws_subnet.private_subnets[2].id
  description = "The private IP address of the main server instance."
}

output "public_subnet-a" {
  value       = aws_subnet.public_subnets[0].id
  description = "The private IP address of the main server instance."
}

output "public_subnet-b" {
  value       = aws_subnet.public_subnets[1].id
  description = "The private IP address of the main server instance."
}

output "public_subnet-c" {
  value       = aws_subnet.public_subnets[2].id
  description = "The private IP address of the main server instance."
}

output "vpc_id" {
    value       = aws_vpc.main.id
}