variable "nodejs_service" {
  description = "Configuration for Node.js ECS service"
  type        = any
}

variable "mongodb_service" {
  description = "Configuration for MongoDB ECS service"
  type        = any
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
}


variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "prometheus_task_definition_arn" {
  description = "ARN of the Prometheus task definition"
  type        = string
}

variable "prometheus_tg_arn" {
  description = "Prometheus target group ARN"
  type        = string
}

variable "grafana_tg_arn" {
  type = string
}

variable "grafana_task_def_arn" {
  type = string
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name"
}
