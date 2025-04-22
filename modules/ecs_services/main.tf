resource "aws_ecs_service" "nodejs" {
  name            = var.nodejs_service.name
  cluster         = var.nodejs_service.cluster
  task_definition = var.nodejs_service.task_definition
  launch_type     = var.nodejs_service.launch_type
  desired_count   = var.nodejs_service.desired_count

 # network_configuration {
  #  subnets         = var.subnet_ids
   # security_groups = var.security_group_ids
    #assign_public_ip = true
  #}
}


resource "aws_ecs_service" "mongodb" {
  name            = var.mongodb_service.name
  cluster         = var.mongodb_service.cluster
  task_definition = var.mongodb_service.task_definition
  launch_type     = var.mongodb_service.launch_type
  desired_count   = var.mongodb_service.desired_count

  #network_configuration {
   # subnets         = var.subnet_ids
    #security_groups = var.security_group_ids
   # assign_public_ip = true
  #}
}

resource "aws_ecs_service" "prometheus" {
  name            = "prometheus-service-${var.environment}"
  cluster         = var.cluster_id
  task_definition = var.prometheus_task_definition_arn

  launch_type     = "EC2"

  load_balancer {
    target_group_arn = var.prometheus_tg_arn
    container_name = "prometheus-container"
    container_port   = 9090
  }

   #network_configuration {
  #  subnets         = var.subnet_ids
 #   security_groups = var.security_group_ids
#   }

  desired_count = 1
}
