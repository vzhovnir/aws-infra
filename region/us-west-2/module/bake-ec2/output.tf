output "sg" {
  value       = aws_security_group.ec2.id
  description = "The private IP address of the main server instance."
}