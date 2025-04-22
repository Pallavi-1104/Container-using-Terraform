# Add this block at the top to fetch the latest Amazon Linux 2 ECS-optimized AMI
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-"
  image_id      = data.aws_ssm_parameter.ecs_ami.value
  instance_type = "t2.micro"

  key_name = var.key_name

  iam_instance_profile {
    name = var.instance_profile_name
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
              mkdir -p /ecs/mongo-data
              yum install -y docker
              systemctl start docker
              systemctl enable docker
              EOF
  )

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ECS Launch Template Instance"
    }
  }
}

resource "aws_autoscaling_group" "ecs" {
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  vpc_zone_identifier  = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
}
