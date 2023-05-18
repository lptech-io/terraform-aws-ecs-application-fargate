variable "deregistration_delay" {
  default     = 30
  description = "Amount of time, in seconds, for Elastic Load Balancer to wait before changing the state of a deregistering target from draining to unused"
  type        = number
}

variable "health_check" {
  description = "Health Check configuration block"
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

variable "target_group_name" {
  description = "Service name as reference for the target group"
  type        = string
}

variable "vpc_id" {
  description = "Identifier of the VPC in which to create the target group"
  type        = string
}
