# Module details

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 1.3 |
| aws | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| ecs\_service | git::https://github.com/a-cube-io/cloudops.infrastructure.tf-library.base.git//aws/ecs/fargate-service | n/a |
| load\_balancer | git::https://github.com/a-cube-io/cloudops.infrastructure.tf-library.base.git//aws/alb | n/a |
| repository | git::https://github.com/a-cube-io/cloudops.infrastructure.tf-library.base.git//aws/ecr/repository | n/a |
| target\_group | ./modules/target-group | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_lb_listener_rule.public_url_on_443](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_security_group_rule.ingress_from_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| autoscaling\_configuration | Autoscaling configuration for ECS service | ```object({ max_connections_per_container = optional(number, 500) max_capacity = number min_capacity = number })``` | n/a | yes |
| cluster\_arn | The ARN of an already existing ECS cluster. Required if no cluster\_properties has been given | `string` | `null` | no |
| cluster\_properties | Cluster configuration block | ```object({ id = optional(string) metrics_enabled = optional(bool, true) name = optional(string) })``` | n/a | yes |
| container\_definitions | Container definitions for the ECS service | ```list(object({ command = optional(list(string)) cpu = optional(number) entryPoint = optional(list(string)) environment = optional(list(object({ name = string value = string }))) essential = optional(bool) firelensConfiguration = optional(object({ type = string options = object({ config-file-type = string enable-ecs-log-metadata = bool config-file-value = string }) })) image = string logConfiguration = optional(object({ logDriver = string options = optional(map(string)) })) memory = optional(number) name = string portMappings = optional(list(object({ hostPort = optional(number) containerPort = number protocol = string }))) secrets = optional(list(object({ name = string valueFrom = string }))) }))``` | n/a | yes |
| enable\_ecr\_tag\_immutability | Enable/Disable tag immutability on ECR repository | `bool` | `false` | no |
| execution\_role\_policies | AWS IAM policies that ECS might need | ```list(object({ name = string statement = list(object({ Action = list(string) Effect = string Resource = list(string) })) }))``` | `[]` | no |
| lb\_arn | The ARN of an already existing load balancer. Required if no lb\_configuration has been given | `string` | `null` | no |
| lb\_configuration | Load balancer block configuration. Required if no lb\_arn has been given | ```object({ certificate_arn = string is_internal = optional(bool, true) elb_security_policy = optional(string) logs_bucket_arn = optional(string) name = string subnet_ids = list(string) })``` | ```{ "certificate_arn": null, "elb_security_policy": null, "is_internal": false, "logs_bucket_arn": null, "name": null, "subnet_ids": [] }``` | no |
| lb\_security\_group\_id | Security group ID if lb\_arn variable is defined | `string` | `null` | no |
| listener\_rule\_arn | The ARN of an already existing listener rule on the given load balancer arn defined. Required if no lb\_configuration has been given | `string` | `null` | no |
| public\_url | Public URL for the service | `string` | n/a | yes |
| repository\_prefix | ECR repository prefix | `string` | n/a | yes |
| service\_configuration | The ECS service configuration block | ```object({ cpu = optional(number, 1024) entrypoint_container_name = string entrypoint_container_port = number health_check_grace_period_in_seconds = optional(number, 60) memory = optional(number, 2048) name = string subnets = list(string) })``` | n/a | yes |
| target\_group\_name | Target group name | `string` | n/a | yes |
| task\_role\_policies | AWS IAM policies that the application might need | ```list(object({ name = string statement = list(object({ Action = list(string) Effect = string Resource = list(string) })) }))``` | `[]` | no |
| vpc\_id | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_arn | n/a |
| load\_balancer\_arn | n/a |
| service\_arn | n/a |
| service\_security\_group\_id | n/a |
