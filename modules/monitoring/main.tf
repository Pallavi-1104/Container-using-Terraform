resource "aws_ecs_task_definition" "prometheus_task" {
  family                   = var.prometheus_task_definition["family"]
  cpu                      = var.prometheus_task_definition["cpu"]
  memory                   = var.prometheus_task_definition["memory"]
  network_mode             = var.prometheus_task_definition["network_mode"]
  requires_compatibilities = ["EC2"]
  container_definitions    = jsonencode(var.prometheus_task_definition["container_definitions"])
}

resource "aws_ecs_task_definition" "grafana_task" {
  family                   = var.grafana_task_definition["family"]
  cpu                      = var.grafana_task_definition["cpu"]
  memory                   = var.grafana_task_definition["memory"]
  network_mode             = var.grafana_task_definition["network_mode"]
  requires_compatibilities = ["EC2"]
  container_definitions    = jsonencode(var.grafana_task_definition["container_definitions"])
}

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.prometheus_task.arn
  launch_type     = "EC2"
  desired_count   = 1

 # network_configuration {
  #  subnets         = var.subnet_ids
   # security_groups = var.security_group_ids
    #assign_public_ip = true
  #}
}



resource "aws_ecs_service" "grafana" {
  name            = "grafana-service"
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.grafana_task.arn
  launch_type     = "EC2"
  desired_count   = 1

  #network_configuration {
   # subnets         = var.subnet_ids
    #security_groups = var.security_group_ids
    #assign_public_ip = true
  #}
}
