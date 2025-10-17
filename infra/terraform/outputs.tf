# Terraform outputs for Shopping Website Microservices Infrastructure

output "namespace_name" {
  description = "Name of the created Kubernetes namespace"
  value       = kubernetes_namespace.shopping_app.metadata[0].name
}

output "namespace_labels" {
  description = "Labels applied to the namespace"
  value       = kubernetes_namespace.shopping_app.metadata[0].labels
}

output "config_map_name" {
  description = "Name of the created ConfigMap"
  value       = kubernetes_config_map.app_config.metadata[0].name
}

output "secret_name" {
  description = "Name of the created Secret"
  value       = kubernetes_secret.app_secrets.metadata[0].name
  sensitive   = true
}

output "service_account_name" {
  description = "Name of the created ServiceAccount"
  value       = kubernetes_service_account.shopping_app.metadata[0].name
}

output "role_name" {
  description = "Name of the created Role"
  value       = kubernetes_role.shopping_app.metadata[0].name
}

output "rabbitmq_release_name" {
  description = "Name of the RabbitMQ Helm release"
  value       = helm_release.rabbitmq.name
}

output "rabbitmq_release_status" {
  description = "Status of the RabbitMQ Helm release"
  value       = helm_release.rabbitmq.status
}

output "ingress_release_name" {
  description = "Name of the NGINX Ingress Helm release"
  value       = helm_release.ingress_nginx.name
}

output "ingress_release_status" {
  description = "Status of the NGINX Ingress Helm release"
  value       = helm_release.ingress_nginx.status
}

output "network_policy_name" {
  description = "Name of the created NetworkPolicy"
  value       = kubernetes_network_policy.shopping_app.metadata[0].name
}

output "application_info" {
  description = "Information about the deployed application"
  value = {
    namespace     = kubernetes_namespace.shopping_app.metadata[0].name
    app_name      = var.app_name
    environment   = var.environment
    ingress_host  = var.ingress_host
    ingress_port  = var.ingress_port
    replicas      = var.replicas
  }
}

output "security_info" {
  description = "Security-related information"
  value = {
    network_policy_created  = true
    service_account_created = true
    rbac_configured         = true
    secrets_created         = true
  }
}

output "resource_limits" {
  description = "Resource limits configured for the application"
  value = {
    cpu_requests    = var.cpu_requests
    memory_requests = var.memory_requests
    cpu_limits      = var.cpu_limits
    memory_limits   = var.memory_limits
  }
}

output "deployment_status" {
  description = "Status of the infrastructure deployment"
  value = {
    namespace_created       = true
    configmap_created       = true
    secrets_created         = true
    rabbitmq_deployed       = helm_release.rabbitmq.status == "deployed"
    ingress_deployed        = helm_release.ingress_nginx.status == "deployed"
    network_policy_created  = true
    rbac_configured         = true
  }
}

output "connection_info" {
  description = "Connection information for the application"
  value = {
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    configmap = kubernetes_config_map.app_config.metadata[0].name
    secret    = kubernetes_secret.app_secrets.metadata[0].name
    sa        = kubernetes_service_account.shopping_app.metadata[0].name
  }
}


