variable "autoscaling_configuration" {
  description = "Autoscaling configuration for ECS service"
  type = object({
    max_connections_per_container = optional(number, 500)
    max_capacity                  = number
    min_capacity                  = number
  })
}

variable "cluster_arn" {
  default     = null
  description = "The ARN of an already existing ECS cluster. Required if no cluster_properties has been given"
  type        = string
}

variable "cluster_properties" {
  default     = null
  description = "Cluster configuration block"
  type = object({
    id              = optional(string)
    metrics_enabled = optional(bool, true)
    name            = optional(string)
  })
}

variable "container_definitions" {
  description = "Container definitions for the ECS service"
  type = list(object({
    command    = optional(list(string))
    cpu        = optional(number)
    entryPoint = optional(list(string))
    environment = optional(list(object({
      name  = string
      value = string
    })))
    essential = optional(bool)
    firelensConfiguration = optional(object({
      type = string
      options = object({
        config-file-type        = string
        enable-ecs-log-metadata = bool
        config-file-value       = string
      })
    }))
    image = optional(string)
    logConfiguration = optional(object({
      logDriver = string
      options   = optional(map(string))
    }))
    memory = optional(number)
    name   = string
    portMappings = optional(list(object({
      hostPort      = optional(number)
      containerPort = number
      protocol      = string
    })))
    secrets = optional(list(object({
      name      = string
      valueFrom = string
    })))
  }))
}

variable "execution_role_policies" {
  default     = []
  description = "AWS IAM policies that ECS might need"
  type = list(object({
    name = string
    statement = list(object({
      Action   = list(string)
      Effect   = string
      Resource = list(string)
    }))
  }))
}

variable "load_balancer_arn" {
  default     = null
  description = "The ARN of an already existing load balancer. Required if no lb_configuration has been given"
  type        = string
}

variable "load_balancer_security_group_id" {
  default     = null
  description = "Security group ID if lb_arn variable is defined"
  type        = string
}

variable "listener_rule_configuration" {
  description = "Listener rule configuration block"
  type = object({
    arn          = string
    host_header  = optional(list(string))
    paths        = optional(list(string))
    query_string = optional(list(string))
    headers = optional(list(object({
      name   = string
      values = list(string)
    })))
  })
}

variable "repository_mutability" {
  default = null
  description = "(optional) describe your variable"
  type = string
}

variable "repository_prefix" {
  description = "ECR repository prefix"
  type        = string
}

variable "service_configuration" {
  description = "The ECS service configuration block"
  type = object({
    cpu                                  = optional(number, 1024)
    entrypoint_container_name            = string
    entrypoint_container_port            = number
    health_check_grace_period_in_seconds = optional(number, 60)
    memory                               = optional(number, 2048)
    name                                 = string
    subnets                              = list(string)
  })
  validation {
    condition     = can(regex("^[A-Za-z][0-9A-Za-z-]*[0-9A-Za-z]$", var.service_configuration.name))
    error_message = "service_name must start with a letter, can only contains letters, numbers, or hyphens and terminate with a letter or a number"
  }
  validation {
    condition     = length(var.service_configuration.name) > 0 && length(var.service_configuration.name) <= 255
    error_message = "service_name must be between 1 and 255 characters."
  }
}

variable "target_group_name" {
  description = "Target group name"
  type        = string
}

variable "target_group_health_check" {
  description = "Target group health check configuration block"
  type = object({
    enabled             = optional(bool, true)
    healthy_threshold   = optional(number, 2)
    interval            = optional(number, 30)
    matcher             = optional(string, "200")
    path                = optional(string, "/healthy")
    port                = optional(number, 80)
    protocol            = optional(string, "HTTP")
    timeout             = optional(number, 5)
    unhealthy_threshold = optional(number, 5)
  })
}

variable "task_role_policies" {
  default     = []
  description = "AWS IAM policies that the application might need"
  type = list(object({
    name = string
    statement = list(object({
      Action   = list(string)
      Effect   = string
      Resource = list(string)
    }))
  }))
}

variable "vpc_id" {
  description = "VPC id"
  type        = string
}
