# modules/launch_template/outputs.tf
output "launch_template_id" {
  value = aws_launch_template.ecs.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.ecs.name
}
