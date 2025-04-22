output "nodejs_task_definition" {
  value = aws_ecs_task_definition.nodejs
}

output "mongodb_task_definition" {
  value = aws_ecs_task_definition.mongodb
}
