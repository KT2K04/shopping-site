# Terraform outputs for Shopping Website Microservices Infrastructure
# 
# Outputs provide important information after infrastructure deployment:
# - Service endpoints and access URLs
# - Resource identifiers for further configuration
# - Status information for verification
# - Connection details for applications

# Namespace Information
output "namespace_name" {
  description = "Name of the created Kubernetes namespace"
  value       = kubernetes_namespace.shopping_app.metadata[0].name
}

output "namespace_labels" {
  description = "Labels applied to the namespace"
  value       = kubernetes_namespace.shopping_app.metadata[0].labels
}

# Application Configuration
output "config_map_name" {
  description = "Name of the created ConfigMap"
  value       = kubernetes_config_map.app_config.metadata[0].name
}

output "secret_name" {
  description = "Name of the created Secret"
  value       = kubernetes_secret.app_secrets.metadata[0].name
  sensitive   = true
}

# Service Account Information
output "service_account_name" {
  description = "Name of the created ServiceAccount"
  value       = kubernetes_service_account.shopping_app.metadata[0].name
}

output "role_name" {
  description = "Name of the created Role"
  value       = kubernetes_role.shopping_app.metadata[0].name
}

# Helm Releases
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

# Network Policy
output "network_policy_name" {
  description = "Name of the created NetworkPolicy"
  value       = kubernetes_network_policy.shopping_app.metadata[0].name
}

# Application Access Information
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

# Security Information
output "security_info" {
  description = "Security-related information"
  value = {
    network_policy_created = true
    service_account_created = true
    rbac_configured = true
    secrets_created = true
  }
}

# Resource Usage Information
output "resource_limits" {
  description = "Resource limits configured for the application"
  value = {
    cpu_requests    = var.cpu_requests
    memory_requests = var.memory_requests
    cpu_limits      = var.cpu_limits
    memory_limits   = var.memory_limits
  }
}

# Deployment Status
output "deployment_status" {
  description = "Status of the infrastructure deployment"
  value = {
    namespace_created     = true
    configmap_created     = true
    secrets_created       = true
    rabbitmq_deployed     = helm_release.rabbitmq.status == "deployed"
    ingress_deployed      = helm_release.ingress_nginx.status == "deployed"
    network_policy_created = true
    rbac_configured       = true
  }
}

# Connection Information
output "connection_info" {
  description = "Connection information for the application"
  value = {
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    configmap = kubernetes_config_map.app_config.metadata[0].name
    secret    = kubernetes_secret.app_secrets.metadata[0].name
    sa        = kubernetes_service_account.shopping_app.metadata[0].name
  }
}

# Next Steps Information
output "next_steps" {
  description = "Next steps after infrastructure deployment"
  value = {
    message = "Infrastructure deployed successfully! Next steps:"
    steps = [
      "1. Apply Kubernetes manifests for microservices",
      "2. Verify all pods are running: kubectl get pods -n ${kubernetes_namespace.shopping_app.metadata[0].name}",
      "3. Check services: kubectl get svc -n ${kubernetes_namespace.shopping_app.metadata[0].name}",
      "4. Test application endpoints",
      "5. Monitor application logs and metrics"
    ]
  }
}
