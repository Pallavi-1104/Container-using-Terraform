provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "./modules/network"
  vpc_cidr_block  = "10.0.0.0/16"
}


module "ecs_cluster" {
  source = "./modules/ecs_cluster"

  cluster_name      = "ecs-cluster"
  subnet_id         = module.network.private_subnet_ids[0]
  security_group_id = module.security.security_group_id
  key_name          = "N.virginia-key"


}

module "ecs_task_definitions" {
  source = "./modules/ecs_task_definitions"

  nodejs_task_definition = {
    family                   = "nodejs-task"
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "bridge"
    requires_compatibilities = ["EC2"]
    container_definitions = [
      {
        name  = "nodejs"
        image = "node:18"
        cpu   = 10
        portMappings = [
          {
            containerPort = 3000
            hostPort      = 3000
            protocol      = "tcp"
          }
        ]
      }
    ]
  }

  mongodb_task_definition = {
    family                   = "mongodb-task"
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "bridge"
    requires_compatibilities = ["EC2"]
    container_definitions = [
      {
        name  = "mongodb"
        image = "mongo:latest"
        cpu   = 10
        portMappings = [
          {
            containerPort = 27017
            hostPort      = 27017
            protocol      = "tcp"
          }
        ]
        mountPoints = [
          {
            sourceVolume  = "mongo-volume"
            containerPath = "/data/db"
          }
        ]
      }
    ]
  }
}

module "security" {
  source = "./modules/security"
  vpc_id = module.network.vpc_id
}

module "ecs_services" {
  source = "./modules/ecs_services"

  # Node.js & MongoDB services
  nodejs_service = {
    name            = "nodejs-service"
    cluster         = module.ecs_cluster.cluster_name
    task_definition = module.ecs_task_definitions.nodejs_task_definition.arn
    launch_type     = "EC2"
    desired_count   = 1
  }

  mongodb_service = {
    name            = "mongodb-service"
    cluster         = module.ecs_cluster.cluster_name
    task_definition = module.ecs_task_definitions.mongodb_task_definition.arn
    launch_type     = "EC2"
    desired_count   = 1
  }

  cluster_id              = module.ecs_cluster.cluster_id
  prometheus_tg_arn       = module.alb.prometheus_tg_arn
  prometheus_task_definition_arn = module.monitoring.prometheus_task_definition_arn
  grafana_tg_arn          = module.alb.grafana_tg_arn
  grafana_task_def_arn    = module.monitoring.grafana_task_definition

  subnet_ids         = module.network.private_subnet_ids
  security_group_ids = [module.security.security_group_id]
}



module "monitoring" {
  source = "./modules/monitoring"

  cluster_name       = module.ecs_cluster.cluster_name
  subnet_ids         = module.network.private_subnet_ids
  security_group_ids = [module.security.security_group_id]

  prometheus_task_definition = {
    family                   = "prometheus-task"
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "bridge"
    requires_compatibilities = ["EC2"]
    container_definitions = [
      {
        name      = "prometheus-container"
        image     = "prom/prometheus:latest"
        cpu       = 10
        essential = true
        portMappings = [
          {
            containerPort = 9090
            hostPort      = 9090
            protocol      = "tcp"
          }
        ]
      }
    ]
  }

  grafana_task_definition = {
    family                   = "grafana-task"
    cpu                      = "256"
    memory                   = "512"
    network_mode             = "bridge"
    requires_compatibilities = ["EC2"]
    container_definitions = [
      {
        name      = "grafana-container"
        image     = "grafana/grafana:latest"
        cpu       = 10
        essential = true
        portMappings = [
          {
            containerPort = 3000
            hostPort      = 3000
            protocol      = "tcp"
          }
        ]
      }
    ]
  }
}

module "launch_template" {
  source = "./modules/launch_template"

  cluster_name          = module.ecs_cluster.cluster_name
  key_name              = var.key_name
  instance_profile_name = module.ecs_cluster.instance_profile_name
  security_group_id     = module.security.security_group_id
  public_subnet_ids     = module.network.public_subnet_ids
}


module "alb" {
  source            = "./modules/alb"
  alb_sg_id         = module.security.security_group_id
  public_subnet_ids = module.network.public_subnet_ids
  vpc_id            = module.network.vpc_id
}
