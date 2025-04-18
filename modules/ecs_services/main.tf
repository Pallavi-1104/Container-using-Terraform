resource "aws_ecs_service" "nodejs" {
  name            = var.nodejs_service.name
  cluster         = var.nodejs_service.cluster
  task_definition = var.nodejs_service.task_definition
  launch_type      = var.nodejs_service.launch_type
  desired_count   = var.nodejs_service.desired_count
}

resource "aws_ecs_service" "mongodb" {
  name            = var.mongodb_service.name
  cluster         = var.mongodb_service.cluster
  task_definition = var.mongodb_service.task_definition
  launch_type      = var.mongodb_service.launch_type
  desired_count   = var.mongodb_service.desired_count
}
