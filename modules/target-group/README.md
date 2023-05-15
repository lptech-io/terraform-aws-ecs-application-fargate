<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.50 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.50 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb_target_group.target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Amount of time, in seconds, for Elastic Load Balancer to wait before changing the state of a deregistering target from draining to unused | `number` | `30` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Health Check configuration block | <pre>object({<br>    enabled             = optional(bool, true)<br>    healthy_threshold   = optional(number, 2)<br>    interval            = optional(number, 10)<br>    matcher             = optional(string, "200")<br>    path                = optional(string, "/healthy")<br>    port                = optional(number, 80)<br>    protocol            = optional(string, "HTTP")<br>    timeout             = optional(number, 5)<br>    unhealthy_threshold = optional(number, 5)<br>  })</pre> | n/a | yes |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Service name as reference for the target group | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Identifier of the VPC in which to create the target group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Target group ARN |
| <a name="output_id"></a> [id](#output\_id) | Target group ID |
| <a name="output_name"></a> [name](#output\_name) | Target group name |
<!-- END_TF_DOCS -->