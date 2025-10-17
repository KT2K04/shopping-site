# Terraform configuration for Shopping Website Microservices
# Demonstrates IaC for local Kubernetes deployment

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

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

locals {
  namespace   = var.namespace
  app_name    = var.app_name
  environment = var.environment
}

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

resource "kubernetes_secret" "app_secrets" {
  metadata {
    name      = "${local.app_name}-secrets"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
  }

  type = "Opaque"

  data = {
    jwt-secret    = base64encode(var.jwt_secret)
    db-password   = base64encode(var.db_password)
    rabbitmq-pass = base64encode(var.rabbitmq_password)
  }
}

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
      metrics = { enabled = true }
      resources = {
        requests = { memory = "256Mi", cpu = "250m" }
        limits   = { memory = "512Mi", cpu = "500m" }
      }
      securityContext = { runAsNonRoot = true, runAsUser = 999, fsGroup = 999 }
    })
  ]

  depends_on = [kubernetes_namespace.shopping_app]
}

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
        service = { type = "NodePort" }
        resources = {
          requests = { memory = "128Mi", cpu = "100m" }
          limits   = { memory = "256Mi", cpu = "200m" }
        }
        securityContext = { runAsNonRoot = true, runAsUser = 101 }
      }
    })
  ]
}

resource "kubernetes_service_account" "shopping_app" {
  metadata {
    name      = "${local.app_name}-sa"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
  }
}

resource "kubernetes_role" "shopping_app" {
  metadata {
    name      = "${local.app_name}-role"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "configmaps", "secrets"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "shopping_app" {
  metadata {
    name      = "${local.app_name}-role-binding"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
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

resource "kubernetes_network_policy" "shopping_app" {
  metadata {
    name      = "${local.app_name}-network-policy"
    namespace = kubernetes_namespace.shopping_app.metadata[0].name
  }

  spec {
    pod_selector {
      match_labels = { app = local.app_name }
    }

    policy_types = ["Ingress", "Egress"]

    ingress {
      from { namespace_selector { match_labels = { name = "ingress-nginx" } } }
      ports { protocol = "TCP" port = 3000 }
    }

    egress {
      to { namespace_selector { match_labels = { name = local.namespace } } }
      ports { protocol = "TCP" port = 3000 }
    }
  }
}


