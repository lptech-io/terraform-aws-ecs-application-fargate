output "cluster_arn" {
  value = module.ecs_service.cluster_arn
}

output "service_arn" {
  value = module.ecs_service.service_arn
}

output "service_security_group_id" {
  value = module.ecs_service.security_group_id
}
