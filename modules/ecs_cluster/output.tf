output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ecs_instance_profile.name
}

output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "vpc_id" {
  value = aws_vpc.this.id
}
