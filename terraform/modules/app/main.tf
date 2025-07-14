resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
    labels = {
      app = var.app_name
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.app_name
      }
    }
    template {
      metadata {
        labels = {
          app = var.app_name
        }
      }
      spec {
        container {
          name  = var.app_name
          image = var.image
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = var.app_name
    namespace = var.namespace
  }
  spec {
    selector = {
      app = var.app_name
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "LoadBalancer"
  }
} 