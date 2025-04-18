resource "aws_ecs_task_definition" "nodejs" {
  family                = var.nodejs_task_definition.family
  cpu                    = var.nodejs_task_definition.cpu
  memory                = var.nodejs_task_definition.memory
  network_mode          = var.nodejs_task_definition.network_mode
  container_definitions = var.nodejs_task_definition.container_definitions
}

resource "aws_ecs_task_definition" "mongodb" {
  family                = var.mongodb_task_definition.family
  cpu                    = var.mongodb_task_definition.cpu
  memory                = var.mongodb_task_definition.memory
  network_mode          = var.mongodb_task_definition.network_mode
  container_definitions = var.mongodb_task_definition.container_definitions
}

