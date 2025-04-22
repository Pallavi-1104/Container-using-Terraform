variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}
