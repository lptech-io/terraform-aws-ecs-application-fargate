output "arn" {
  description = "Target group ARN"
  value       = aws_lb_target_group.target_group.arn
}

output "id" {
  description = "Target group ID"
  value       = aws_lb_target_group.target_group.id
}

output "name" {
  description = "Target group name"
  value       = aws_lb_target_group.target_group.name
}
