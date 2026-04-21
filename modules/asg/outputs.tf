output "autoscaling_group_name" {
  value = aws_autoscaling_group.web.name
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}