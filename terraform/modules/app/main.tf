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
          volume_mount {
            name       = "${var.app_name}-config-html"
            mount_path = "/usr/share/nginx/html/config.html"
            sub_path   = "config.html"
            read_only  = true
          }
        }
        volume {
          name = "${var.app_name}-config-html"
          config_map {
            name = "${var.app_name}-config-html"
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

resource "kubernetes_config_map" "config_html" {
  metadata {
    name      = "${var.app_name}-config-html"
    namespace = var.namespace
  }
  data = {
    "config.html" = <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ConfigMap Page</title>
</head>
<body>
    <h1>This page is served from a Kubernetes ConfigMap!</h1>
    <p>You can update this content by editing the ConfigMap, no image rebuild required.</p>
</body>
</html>
EOF
  }
}
