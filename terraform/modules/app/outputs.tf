output "service_external_hostname" {
  description = "The external hostname of the LoadBalancer service"
  value = kubernetes_service.app.status[0].load_balancer[0].ingress[0].hostname
}

output "deployment_name" {
  description = "The name of the deployment"
  value = kubernetes_deployment.app.metadata[0].name
} 