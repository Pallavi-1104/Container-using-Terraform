output "private_subnet_ids" {
  value = [for subnet in aws_subnet.private : subnet.id]
}

output "vpc_id" {
  value = aws_vpc.this.id
}


output "public_subnet_ids" {
  value = aws_subnet.public_1[*].id
}
