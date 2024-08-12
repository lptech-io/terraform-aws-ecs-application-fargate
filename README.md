<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs_service"></a> [ecs\_service](#module\_ecs\_service) | lptech-io/ecs-service-fargate/aws | n/a |
| <a name="module_repository"></a> [repository](#module\_repository) | lptech-io/ecr-repository/aws | >= 1.2.0 |
| <a name="module_target_group"></a> [target\_group](#module\_target\_group) | ./modules/target-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_lb_listener_rule.public_url_on_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_security_group_rule.ingress_from_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.image_arn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_configuration"></a> [autoscaling\_configuration](#input\_autoscaling\_configuration) | Autoscaling configuration for ECS service | <pre>object({<br>    max_connections_per_container = optional(number, 500)<br>    max_capacity                  = number<br>    min_capacity                  = number<br>  })</pre> | n/a | yes |
| <a name="input_cluster_arn"></a> [cluster\_arn](#input\_cluster\_arn) | The ARN of an already existing ECS cluster. Required if no cluster\_properties has been given | `string` | `null` | no |
| <a name="input_cluster_properties"></a> [cluster\_properties](#input\_cluster\_properties) | Cluster configuration block | <pre>object({<br>    id              = optional(string)<br>    metrics_enabled = optional(bool, true)<br>    name            = optional(string)<br>  })</pre> | `null` | no |
| <a name="input_container_definitions"></a> [container\_definitions](#input\_container\_definitions) | Container definitions for the ECS service | <pre>list(object({<br>    command    = optional(list(string))<br>    cpu        = optional(number)<br>    entryPoint = optional(list(string))<br>    environment = optional(list(object({<br>      name  = string<br>      value = string<br>    })))<br>    essential = optional(bool)<br>    firelensConfiguration = optional(object({<br>      type = string<br>      options = object({<br>        config-file-type        = string<br>        enable-ecs-log-metadata = bool<br>        config-file-value       = string<br>      })<br>    }))<br>    image = optional(string)<br>    logConfiguration = optional(object({<br>      logDriver = string<br>      options   = optional(map(string))<br>    }))<br>    memory = optional(number)<br>    name   = string<br>    portMappings = optional(list(object({<br>      hostPort      = optional(number)<br>      containerPort = number<br>      protocol      = string<br>    })))<br>    secrets = optional(list(object({<br>      name      = string<br>      valueFrom = string<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_execution_role_policies"></a> [execution\_role\_policies](#input\_execution\_role\_policies) | AWS IAM policies that ECS might need | <pre>list(object({<br>    name = string<br>    statement = list(object({<br>      Action   = list(string)<br>      Effect   = string<br>      Resource = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_listener_rule_configuration"></a> [listener\_rule\_configuration](#input\_listener\_rule\_configuration) | Listener rule configuration block | <pre>object({<br>    arn          = string<br>    host_header  = optional(list(string))<br>    paths        = optional(list(string))<br>    query_string = optional(list(string))<br>    headers = optional(list(object({<br>      name   = string<br>      values = list(string)<br>    })))<br>  })</pre> | n/a | yes |
| <a name="input_load_balancer_arn"></a> [load\_balancer\_arn](#input\_load\_balancer\_arn) | The ARN of an already existing load balancer. Required if no lb\_configuration has been given | `string` | `null` | no |
| <a name="input_load_balancer_security_group_id"></a> [load\_balancer\_security\_group\_id](#input\_load\_balancer\_security\_group\_id) | Security group ID if lb\_arn variable is defined | `string` | `null` | no |
| <a name="input_repositories_details"></a> [repositories\_details](#input\_repositories\_details) | ECR configuration for containers | <pre>map(object({<br>    mutability = optional(string, "IMMUTABLE")<br>    lifecycle_rule = optional(object({<br>      enable = optional(bool, true)<br>      images_to_retain = optional(number, 10)<br>    }))<br>    ssm_parameter_name = optional(string, "")<br>  }))</pre> | `{}` | no |
| <a name="input_repository_prefix"></a> [repository\_prefix](#input\_repository\_prefix) | ECR repository prefix | `string` | n/a | yes |
| <a name="input_service_configuration"></a> [service\_configuration](#input\_service\_configuration) | The ECS service configuration block | <pre>object({<br>    cpu                                  = optional(number, 1024)<br>    entrypoint_container_name            = string<br>    entrypoint_container_port            = number<br>    health_check_grace_period_in_seconds = optional(number, 60)<br>    memory                               = optional(number, 2048)<br>    name                                 = string<br>    subnets                              = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_ssm_parameter_name"></a> [ssm\_parameter\_name](#input\_ssm\_parameter\_name) | Name of SSM parameter where store container tag image | `string` | `""` | no |
| <a name="input_target_group_health_check"></a> [target\_group\_health\_check](#input\_target\_group\_health\_check) | Target group health check configuration block | <pre>object({<br>    enabled             = optional(bool, true)<br>    healthy_threshold   = optional(number, 2)<br>    interval            = optional(number, 30)<br>    matcher             = optional(string, "200")<br>    path                = optional(string, "/healthy")<br>    port                = optional(number, 80)<br>    protocol            = optional(string, "HTTP")<br>    timeout             = optional(number, 5)<br>    unhealthy_threshold = optional(number, 5)<br>  })</pre> | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Target group name | `string` | n/a | yes |
| <a name="input_task_role_policies"></a> [task\_role\_policies](#input\_task\_role\_policies) | AWS IAM policies that the application might need | <pre>list(object({<br>    name = string<br>    statement = list(object({<br>      Action   = list(string)<br>      Effect   = string<br>      Resource = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | n/a |
| <a name="output_service_arn"></a> [service\_arn](#output\_service\_arn) | n/a |
| <a name="output_service_security_group_id"></a> [service\_security\_group\_id](#output\_service\_security\_group\_id) | n/a |
<!-- END_TF_DOCS -->
