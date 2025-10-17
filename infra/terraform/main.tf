##############################
# Terraform Initialization
##############################
terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

##############################
# Provider Configuration
##############################
provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

##############################
# Namespace for App
##############################
resource "kubernetes_namespace" "shopping" {
  metadata {
    name = "shopping-app"
  }
}

##############################
# RabbitMQ Helm Deployment
##############################
resource "helm_release" "rabbitmq" {
  name       = "rabbitmq"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "rabbitmq"
  namespace  = kubernetes_namespace.shopping.metadata[0].name
  version    = "11.8.0"

  # Ensures RabbitMQ has enough time to initialize
  timeout    = 600
  atomic     = true
  cleanup_on_fail = true

  values = [
    yamlencode({
      auth = {
        username = "guest"
        password = "guest"
      }
      service = {
        type = "ClusterIP"
      }
      persistence = {
        enabled = false
      }
      volumePermissions = {
        enabled = true
      }
      resources = {
        requests = {
          cpu    = "100m"
          memory = "256Mi"
        }
        limits = {
          cpu    = "300m"
          memory = "512Mi"
        }
      }
    })
  ]
}

##############################
# Shopping App Deployments
##############################
resource "kubernetes_deployment" "login_service" {
  metadata {
    name      = "login-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
    labels = {
      app = "login-service"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "login-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "login-service"
        }
      }
      spec {
        container {
          name  = "login-service"
          image = "your-dockerhub-username/login-service:latest"
          port {
            container_port = 3001
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "login_service" {
  metadata {
    name      = "login-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
  }
  spec {
    selector = {
      app = "login-service"
    }
    port {
      port        = 3001
      target_port = 3001
    }
    type = "ClusterIP"
  }
}

##############################
# Order Service
##############################
resource "kubernetes_deployment" "order_service" {
  metadata {
    name      = "order-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
    labels = {
      app = "order-service"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "order-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "order-service"
        }
      }
      spec {
        container {
          name  = "order-service"
          image = "your-dockerhub-username/order-service:latest"
          port {
            container_port = 3002
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "order_service" {
  metadata {
    name      = "order-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
  }
  spec {
    selector = {
      app = "order-service"
    }
    port {
      port        = 3002
      target_port = 3002
    }
    type = "ClusterIP"
  }
}

##############################
# Payment Service
##############################
resource "kubernetes_deployment" "payment_service" {
  metadata {
    name      = "payment-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
    labels = {
      app = "payment-service"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "payment-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "payment-service"
        }
      }
      spec {
        container {
          name  = "payment-service"
          image = "your-dockerhub-username/payment-service:latest"
          port {
            container_port = 3003
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "payment_service" {
  metadata {
    name      = "payment-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
  }
  spec {
    selector = {
      app = "payment-service"
    }
    port {
      port        = 3003
      target_port = 3003
    }
    type = "ClusterIP"
  }
}

##############################
# Inventory Service
##############################
resource "kubernetes_deployment" "inventory_service" {
  metadata {
    name      = "inventory-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
    labels = {
      app = "inventory-service"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "inventory-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "inventory-service"
        }
      }
      spec {
        container {
          name  = "inventory-service"
          image = "your-dockerhub-username/inventory-service:latest"
          port {
            container_port = 3004
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "inventory_service" {
  metadata {
    name      = "inventory-service"
    namespace = kubernetes_namespace.shopping.metadata[0].name
  }
  spec {
    selector = {
      app = "inventory-service"
    }
    port {
      port        = 3004
      target_port = 3004
    }
    type = "ClusterIP"
  }
}
