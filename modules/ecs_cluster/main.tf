data "aws_availability_zones" "available" {}


resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_instance" "ecs_instance" {
  ami                    = data.aws_ssm_parameter.ecs_ami.value
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  security_groups        = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = aws_iam_instance_profile.ecs_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
              mkdir -p /ecs/mongo-data
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              EOF

  tags = {
    Name = "ECS EC2 Instance"
  }
}

resource "aws_iam_role" "ecs_instance_role" {
  name        = "ecs-instance-role"
  description = "Role for ECS instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecs-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

# Create VPC
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

# Create Subnet
resource "aws_subnet" "public_1" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.this.id
  availability_zone = data.aws_availability_zones.available.names[0]

}

# Create InternetGateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

# Create RouteTable
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Create Route-Table-Association
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}
