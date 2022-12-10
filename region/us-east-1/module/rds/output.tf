output "endpoint" {
  value       = aws_db_instance.default.endpoint
  description = "The private IP address of the main server instance."
}