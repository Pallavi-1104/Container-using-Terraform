variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region to deploy to"
}


# Network Variables

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}


# ECS Cluster / EC2

variable "key_name" {
  type = string
}

variable "cluster_name" {
  type = string
}


# Task Definitions for ECS

variable "prometheus_task_definition" {
  type = any
}

variable "grafana_task_definition" {
  type = any
}

variable "nodejs_task_definition" {
  type = any
}

variable "mongodb_task_definition" {
  type = any
}

variable "environment" {
  description = "Deployment environment name (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}
