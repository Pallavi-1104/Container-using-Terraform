resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

# Create EC2 Instance for ECS Cluster
resource "aws_instance" "ecs_instance" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name
}

# Create IAM Role for ECS Instance
resource "aws_iam_role" "ecs_instance_role" {
  name        = "ecs-instance-role"
  description = "Role for ECS instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

# Create IAM Instance Profile for ECS Instance
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

# Create Subnet
resource "aws_subnet" "example" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.example.id
  availability_zone = "us-west-2a"
}

# Create VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
