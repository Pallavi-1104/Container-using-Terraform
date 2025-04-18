provider "aws" {
  region = "us-west-2"
}

module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  cluster_name = "example-cluster"
}

module "ecs_task_definitions" {
  source = "./modules/ecs_task_definitions"

  nodejs_task_definition = {
    family                = "nodejs-task"
    cpu                    = "256"
    memory                = "512"
    network_mode          = "bridge"
    container_definitions = jsonencode([
      {
        name        = "nodejs-container"
        image       = "node:latest"
        cpu         = 10
        essential   = true
        portMappings = [
          {
            containerPort = 3000
            hostPort      = 3000
            protocol      = "tcp"
          }
        ]
      }
    ])
  }

  mongodb_task_definition = {
    family                = "mongodb-task"
    cpu                    = "256"
    memory                = "512"
    network_mode          = "bridge"
    container_definitions = jsonencode([
      {
        name        = "mongodb-container"
        image       = "mongo:latest"
        cpu         = 10
        essential   = true
        portMappings = [
          {
            containerPort = 27017
            hostPort      = 27017
            protocol      = "tcp"
          }
        ]
      }
    ])
  }
}

module "ecs_services" {
  source = "./modules/ecs_services"

  nodejs_service = {
    name            = "nodejs-service"
    cluster         = module.ecs_cluster.cluster_name
    task_definition = module.ecs_task_definitions.nodejs_task_definition.arn
    launch_type      = "EC2"
    desired_count   = 1
  }

  mongodb_service = {
    name            = "mongodb-service"
    cluster         = module.ecs_cluster.cluster_name
    task_definition = module.ecs_task_definitions.mongodb_task_definition.arn
    launch_type      = "EC2"
    desired_count   = 1
  }
}

module "monitoring" {
  source = "./modules/monitoring"

  prometheus_task_definition = {
    family                = "prometheus-task"
    cpu                    = "256"
    memory                = "512"
    network_mode          = "bridge"
    container_definitions = jsonencode([
      {
        name        = "prometheus-container"
        image       = "prom/prometheus:latest"
        cpu         = 10
        essential   = true
        portMappings = [
          {
            containerPort = 9090
            hostPort      = 9090
            protocol      = "tcp"
          }
        ]
      }
    ])
  }

  grafana_task_definition = {
    family                = "grafana-task"
    cpu                    = "256"
    memory                = "512"
    network_mode          = "bridge"
    container_definitions = jsonencode([
      {
        name        = "grafana-container"
        image       = "grafana/grafana:latest"
        cpu         = 10
        essential   = true
        portMappings = [
          {
            containerPort = 3000
            hostPort      = 3000
            protocol      = "tcp"
          }
        ]
      }
    ])
  }
}
