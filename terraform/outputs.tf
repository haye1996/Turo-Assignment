output "app1_service_external_hostname" {
  description = "The external hostname of the LoadBalancer service for app1"
  value = module.app1.service_external_hostname
}

output "app1_deployment_name" {
  description = "The name of the deployment for app1"
  value = module.app1.deployment_name
}

output "app2_service_external_hostname" {
  description = "The external hostname of the LoadBalancer service for app2"
  value = module.app2.service_external_hostname
}

output "app2_deployment_name" {
  description = "The name of the deployment for app2"
  value = module.app2.deployment_name
} 