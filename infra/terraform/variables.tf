# Terraform variables for Shopping Website Microservices Infrastructure
# 
# Variables provide flexibility and reusability:
# - Environment-specific configurations (dev, staging, prod)
# - Easy customization without code changes
# - Consistent values across different deployments
# - Documentation of required inputs

# Application Configuration Variables
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
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

# Kubernetes Configuration
variable "kubeconfig_path" {
  description = "Path to kubeconfig file for local cluster"
  type        = string
  default     = "~/.kube/config"
}

# Application Settings
variable "log_level" {
  description = "Log level for the application"
  type        = string
  default     = "info"
  
  validation {
    condition     = contains(["debug", "info", "warn", "error"], var.log_level)
    error_message = "Log level must be one of: debug, info, warn, error."
  }
}

variable "api_version" {
  description = "API version for the application"
  type        = string
  default     = "v1"
}

# Security Configuration
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

# Helm Chart Versions
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

# Resource Configuration
variable "replicas" {
  description = "Number of replicas for each service"
  type        = number
  default     = 2
  
  validation {
    condition     = var.replicas >= 1 && var.replicas <= 10
    error_message = "Replicas must be between 1 and 10."
  }
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

# Network Configuration
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

# Monitoring Configuration
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
