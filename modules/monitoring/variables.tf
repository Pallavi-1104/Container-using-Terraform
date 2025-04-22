variable "cluster_name" {
  description = "ECS cluster Name"
  type        = string
}


variable "prometheus_task_definition" {
  description = "Prometheus task definition settings"
  type = object({
    family               = string
    cpu                  = string
    memory               = string
    network_mode         = string
    container_definitions = list(any)
  })
}


variable "grafana_task_definition" {
  type = any
}

variable "subnet_ids" {
  description = "List of subnet IDs for ECS service"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for ECS service"
  type        = list(string)
}
