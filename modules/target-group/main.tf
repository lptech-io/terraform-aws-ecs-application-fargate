terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
  required_version = ">= 1.3"
}

resource "aws_lb_target_group" "target_group" {
  deregistration_delay          = var.deregistration_delay
  load_balancing_algorithm_type = "least_outstanding_requests"
  port                          = 80
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  target_type                   = "ip"
  vpc_id                        = var.vpc_id

  health_check {
    enabled             = var.health_check.enabled
    healthy_threshold   = var.health_check.healthy_threshold
    interval            = var.health_check.interval
    matcher             = var.health_check.matcher
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    timeout             = var.health_check.timeout
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }
  tags = {
    "Name" = var.target_group_name
  }
  lifecycle {
    create_before_destroy = true
  }
}
