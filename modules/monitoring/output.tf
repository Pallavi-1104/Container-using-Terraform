output "prometheus_service" {
  value = aws_ecs_service.prometheus
}

output "grafana_service" {
  value = aws_ecs_service.grafana
}


output "prometheus_task_definition_arn" {
  value = aws_ecs_task_definition.prometheus_task.arn
}

output "grafana_task_definition" {
  value = aws_ecs_task_definition.grafana_task.arn
}
