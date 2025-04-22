output "nodejs_service_name" {
  value = aws_ecs_service.nodejs.name
}

output "mongodb_service_name" {
  value = aws_ecs_service.mongodb.name
}
