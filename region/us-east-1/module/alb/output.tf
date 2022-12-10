output "loadbalancer" {
  value       = aws_lb_target_group.petclinic.id
  description = "The private IP address of the main server instance."
}