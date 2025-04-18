resource "aws_ecs_task_definition" "prometheus" {
  family                = var.prometheus_task_definition.family
  cpu                    = var.prometheus_task_definition.cpu
  memory                = var.prometheus_task_definition.memory
  network_mode          = var.prometheus_task_definition.network_mode
  container_definitions = var.prometheus_task_definition.container_definitions
}

resource "aws_ecs_task_definition" "grafana" {
  family                = var.grafana_task_definition.family
  cpu                    = var.grafana_task_definition.cpu
  memory                = var.grafana_task_definition.memory
  network_mode          = var.grafana_task_definition.network_mode
  container_definitions = var.grafana_task_definition.container_definitions
}
