output "ecs_cluster_name" {
  value       = module.ecs_cluster.cluster_name
  description = "Name of the ECS cluster"
}

output "nodejs_service_name" {
  value = module.ecs_services.nodejs_service_name
}

output "mongodb_service_name" {
  value = module.ecs_services.mongodb_service_name
}

output "prometheus_url" {
  value       = "http://${module.monitoring.prometheus_service.name}:9090"
  description = "URL of the Prometheus service"
}

output "grafana_url" {
  value       = "http://${module.monitoring.grafana_service.name}:3000"
  description = "URL of the Grafana service"
}
