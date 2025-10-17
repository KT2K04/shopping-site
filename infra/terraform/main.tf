# Terraform configuration for Shopping Website Microservices
# This demonstrates Infrastructure as Code (IaC) for local Kubernetes deployment
# 
# Benefits of IaC:
# - Reproducibility: Same infrastructure can be created anywhere
# - Version Control: Infrastructure changes are tracked in Git
# - Auditability: All infrastructure changes are documented
# - Consistency: Eliminates manual configuration drift
# - Collaboration: Team members can review and approve infrastructure changes

terraform {
  required_version = ">= 1.0"
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

# Configure Docker provider for local development
provider "docker" {
  host = "npipe:////.//pipe//docker_engine" # Windows Docker Desktop
}

# Configure Kubernetes provider for local cluster
provider "kubernetes" {
  config_path = var.kubeconfig_path
}

# Configure Helm provider for package management
provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

# Local variables for consistent naming
locals {
  namespace = var.namespace
  app_name  = var.app_name
  environment = var.environment
}

# Create namespace for the shopping application
resource "kubernetes_namespace" "shopping_app" {
  metadata {
    name = local.namespace
    labels = {
      name        = local.namespace
      app         = local.app_name
      environment = local.environment
      managed-by  = "terraform"
    }
  }
}

# Create a ConfigMap for application configuration
resource "kubernetes_config_map" "app_config" {
  metadata {
    name      = "${local.app_name}-config"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    labels = {
      app = local.app_name
    }
  }

  data = {
    ENVIRONMENT = local.environment
    LOG_LEVEL   = var.log_level
    API_VERSION = var.api_version
  }
}

# Create a Secret for sensitive configuration
resource "kubernetes_secret" "app_secrets" {
  metadata {
    name      = "${local.app_name}-secrets"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    labels = {
      app = local.app_name
    }
  }

  type = "Opaque"

  data = {
    jwt-secret     = base64encode(var.jwt_secret)
    db-password    = base64encode(var.db_password)
    rabbitmq-pass  = base64encode(var.rabbitmq_password)
  }
}

# Deploy RabbitMQ using Helm chart for better management
resource "helm_release" "rabbitmq" {
  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  version    = var.rabbitmq_chart_version
  namespace  = kubernetes_namespace.shopping_app.metadata[0].name

  values = [
    yamlencode({
      auth = {
        username = "guest"
        password = var.rabbitmq_password
      }
      metrics = {
        enabled = true
      }
      resources = {
        requests = {
          memory = "256Mi"
          cpu    = "250m"
        }
        limits = {
          memory = "512Mi"
          cpu    = "500m"
        }
      }
      securityContext = {
        runAsNonRoot = true
        runAsUser    = 999
        fsGroup      = 999
      }
    })
  ]

  depends_on = [kubernetes_namespace.shopping_app]
}

# Deploy NGINX Ingress Controller for external access
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = var.ingress_chart_version
  namespace  = "ingress-nginx"

  create_namespace = true

  values = [
    yamlencode({
      controller = {
        service = {
          type = "NodePort"
        }
        resources = {
          requests = {
            memory = "128Mi"
            cpu    = "100m"
          }
          limits = {
            memory = "256Mi"
            cpu    = "200m"
          }
        }
        securityContext = {
          runAsNonRoot = true
          runAsUser    = 101
        }
      }
    })
  ]
}

# Create a ServiceAccount for the application
resource "kubernetes_service_account" "shopping_app" {
  metadata {
    name      = "${local.app_name}-sa"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    labels = {
      app = local.app_name
    }
  }
}

# Create a Role for the application
resource "kubernetes_role" "shopping_app" {
  metadata {
    name      = "${local.app_name}-role"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    labels = {
      app = local.app_name
    }
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "configmaps", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
}

# Bind the Role to the ServiceAccount
resource "kubernetes_role_binding" "shopping_app" {
  metadata {
    name      = "${local.app_name}-role-binding"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    labels = {
      app = local.app_name
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.shopping_app.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.shopping_app.metadata[0].name
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
  }
}

# Create a NetworkPolicy for security
resource "kubernetes_network_policy" "shopping_app" {
  metadata {
    name      = "${local.app_name}-network-policy"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
    labels = {
      app = local.app_name
    }
  }

  spec {
    pod_selector {
      match_labels = {
        app = local.app_name
      }
    }

    policy_types = ["Ingress", "Egress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            name = "ingress-nginx"
          }
        }
      }
      ports {
        protocol = "TCP"
        port     = "3000"
      }
    }

    egress {
      to {
        namespace_selector {
          match_labels = {
            name = local.namespace
          }
        }
      }
      ports {
        protocol = "TCP"
        port     = "3000"
      }
    }
  }
}
