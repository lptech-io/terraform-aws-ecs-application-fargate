module "repository" {
  for_each = { for image in var.container_definitions : image.name => image }
  source = "git::https://gitlab.com/opyn.eu/infrastructure/terraform/library/base-modules/aws/ecr.git"
  repository_name           = lower("${var.repository_prefix}-${each.value.name}")
}

data "aws_ssm_parameter" "image_arn" {
  depends_on = [module.repository]
  for_each = { for image in var.container_definitions : image.name => image }
  name = module.repository[each.value.name].ssm_active_container_tag
}

locals {
  container_definitions = [
    for container in var.container_definitions : merge(container, { image = "${data.aws_ssm_parameter.image_arn[container.name].value}"} )
  ]
}

resource "aws_ecs_cluster" "cluster" {
  count = var.cluster_arn == null ? 1 : 0
  name = var.cluster_properties.name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "ecs_service" {
  source = "git::https://gitlab.com/opyn.eu/infrastructure/terraform/library/base-modules/aws/ecs-fargate.git"

  autoscaling_configuration = {
    max_capacity = var.autoscaling_configuration.max_capacity
    min_capacity = var.autoscaling_configuration.min_capacity
  }
  cluster_arn                          = var.cluster_arn != null ? var.cluster_arn : aws_ecs_cluster.cluster[0].id
  container_definitions                = local.container_definitions
  ecr_repository_arns                  = [for repository in module.repository : repository["arn"]]
  execution_role_policies              = var.execution_role_policies
  health_check_grace_period_in_seconds = var.service_configuration.health_check_grace_period_in_seconds
  load_balancer_arn                    = var.load_balancer_arn
  service_name                         = var.service_configuration.name
  subnets                              = var.service_configuration.subnets
  task_definition = {
    entrypoint_container_name = var.service_configuration.entrypoint_container_name
    entrypoint_container_port = var.service_configuration.entrypoint_container_port
  }
  target_group_arn   = module.target_group.arn
  task_role_policies = var.task_role_policies
  vpc_id             = var.vpc_id
}

module "target_group" {
  source = "./modules/target-group"
  health_check = {
    port = var.service_configuration.entrypoint_container_port
  }
  target_group_name = var.target_group_name
  vpc_id            = var.vpc_id
}

resource "aws_lb_listener_rule" "public_url_on_443" {
  listener_arn = var.listener_rule_configuration.arn
  action {
    type             = "forward"
    target_group_arn = module.target_group.arn
  }
  dynamic "condition" {
    for_each = var.listener_rule_configuration.host_header != null ? [""] : []
    content {
      host_header {
        values = var.listener_rule_configuration.host_header
      }
    }
  }
  dynamic "condition" {
    for_each = var.listener_rule_configuration.query_string != null ? [""] : []
    dynamic "query_string" {
      for_each = var.listener_rule_configuration.query_string
      content {
        value = query_string.value
      }
    }
  }
}

resource "aws_security_group_rule" "ingress_from_load_balancer" {
  from_port                = var.service_configuration.entrypoint_container_port
  protocol                 = "tcp"
  security_group_id        = module.ecs_service.security_group_id
  source_security_group_id = var.load_balancer_security_group_id
  to_port                  = var.service_configuration.entrypoint_container_port
  type                     = "ingress"
}
