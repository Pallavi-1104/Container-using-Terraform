variable "mongodb_task_definition" {
  type = object({
    family               = string
    cpu                  = string
    memory               = string
    network_mode         = string
    container_definitions = list(any)
    volumes              = optional(list(any))  # If you're passing volumes
  })
}

variable "nodejs_task_definition" {
  type = object({
    family               = string
    cpu                  = string
    memory               = string
    network_mode         = string
    container_definitions = list(any)
  })
}
