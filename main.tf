module "repository" {
  for_each             = { for container in var.container_definitions : container.name => container if container.image == null}
  source               = "lptech-io/ecr-repository/aws"
  version              = ">= 1.2.0"
  repository_name      = lower("${var.repository_prefix}-${each.value.name}")
  lifecycle_rule       = try(var.repositories_details[each.value.name].lifecycle_rule, {enabled = true, images_to_maintain = 10})
  image_tag_mutability = try(var.repositories_details[each.value.name].mutability, "MUTABLE")
  ssm_parameter_name   = try(var.repositories_details[each.value.name].ssm_parameter_name, "")
}

data "aws_ssm_parameter" "image_arn" {
  depends_on = [module.repository]
  for_each   = { for container in var.container_definitions : container.name => container if container.image == null}
  name       = module.repository[each.value.name].ssm_active_container_tag
}

locals {
  container_definitions = [
    for container in var.container_definitions : merge(container, { image = container.image == null ? "${data.aws_ssm_parameter.image_arn[container.name].value}" : container.image })
  ]
}

resource "aws_ecs_cluster" "cluster" {
  count = var.cluster_arn == null ? 1 : 0
  name  = var.cluster_properties.name
  setting {
    name  = "containerInsights"
    value = var.cluster_properties.metrics_enabled ? "enabled" : "disabled"
  }
}

module "ecs_service" {
  source = "lptech-io/ecs-service-fargate/aws"

  autoscaling_configuration = {
    max_capacity = var.autoscaling_configuration.max_capacity
    min_capacity = var.autoscaling_configuration.min_capacity
  }
  cluster_arn                          = var.cluster_arn != null ? var.cluster_arn : aws_ecs_cluster.cluster[0].id
  container_definitions                = local.container_definitions
  cpu                                  = var.service_configuration.cpu
  ecr_repository_arns                  = [for repository in module.repository : repository["arn"]]
  execution_role_policies              = var.execution_role_policies
  extra_target_groups                  = var.extra_target_groups
  health_check_grace_period_in_seconds = var.service_configuration.health_check_grace_period_in_seconds
  load_balancer_arn                    = var.load_balancer_arn
  memory                               = var.service_configuration.memory
  service_name                         = var.service_configuration.name
  subnets                              = var.service_configuration.subnets
  task_definition = {
    entrypoint_container_name = var.service_configuration.entrypoint_container_name
    entrypoint_container_port = var.service_configuration.entrypoint_container_port
  }
  target_group_arn                   = module.target_group.arn
  task_role_extra_allowed_principals = var.task_role_extra_allowed_principals
  task_role_policies                 = var.task_role_policies
  vpc_id                             = var.vpc_id
}

module "target_group" {
  source            = "./modules/target-group"
  health_check      = var.target_group_health_check
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
    for_each = var.listener_rule_configuration.paths != null ? [""] : []
    content {
      path_pattern {
        values = var.listener_rule_configuration.paths
      }
    }
  }
  dynamic "condition" {
    for_each = var.listener_rule_configuration.query_string != null ? [""] : []
    content {
      dynamic "query_string" {
        for_each = var.listener_rule_configuration.query_string
        content {
          value = query_string.value
        }
      }
    }
  }
  dynamic "condition" {
    for_each = var.listener_rule_configuration.headers != null ? [var.listener_rule_configuration.headers] : []
    content {
      http_header {
        http_header_name = condition.value.name
        values           = condition.value.values
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
