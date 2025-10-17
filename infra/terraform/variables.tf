# Terraform variables for Shopping Website Microservices Infrastructure

variable "app_name" {
  description = "Name of the shopping application"
  type        = string
  default     = "shopping-website"
}

variable "namespace" {
  description = "Kubernetes namespace for the application"
  type        = string
  default     = "shopping-app"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "kubeconfig_path" {
  description = "Path to kubeconfig file for local cluster"
  type        = string
  default     = "~/.kube/config"
}

variable "log_level" {
  description = "Log level for the application"
  type        = string
  default     = "info"
}

variable "api_version" {
  description = "API version for the application"
  type        = string
  default     = "v1"
}

variable "jwt_secret" {
  description = "JWT secret key for authentication"
  type        = string
  default     = "your-jwt-secret-key-change-in-production"
  sensitive   = true
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password123"
  sensitive   = true
}

variable "rabbitmq_password" {
  description = "RabbitMQ password"
  type        = string
  default     = "guest"
  sensitive   = true
}

variable "rabbitmq_chart_version" {
  description = "Version of RabbitMQ Helm chart"
  type        = string
  default     = "11.8.0"
}

variable "ingress_chart_version" {
  description = "Version of NGINX Ingress Helm chart"
  type        = string
  default     = "4.7.1"
}

variable "replicas" {
  description = "Number of replicas for each service"
  type        = number
  default     = 2
}

variable "cpu_requests" {
  description = "CPU requests for containers"
  type        = string
  default     = "100m"
}

variable "memory_requests" {
  description = "Memory requests for containers"
  type        = string
  default     = "128Mi"
}

variable "cpu_limits" {
  description = "CPU limits for containers"
  type        = string
  default     = "200m"
}

variable "memory_limits" {
  description = "Memory limits for containers"
  type        = string
  default     = "256Mi"
}

variable "ingress_host" {
  description = "Hostname for the ingress"
  type        = string
  default     = "shopping-app.local"
}

variable "ingress_port" {
  description = "Port for the ingress"
  type        = number
  default     = 80
}

variable "enable_monitoring" {
  description = "Enable monitoring stack (Prometheus, Grafana)"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enable centralized logging (ELK stack)"
  type        = bool
  default     = false
}


