resource kubernetes_service_account tiller {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/component"  = var.component
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  automount_service_account_token = var.automount_service_account_token
}

resource kubernetes_cluster_role_binding tiller {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/component"  = var.component
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  dynamic "subject" {
    for_each = var.service_namespaces

    content {
      kind      = "ServiceAccount"
      name      = var.name
      namespace = subject.value
      api_group = ""
    }
  }

  depends_on = [
    kubernetes_service_account.tiller,
  ]
}

#------------#
# Deployment #
#------------#
resource kubernetes_deployment tiller {
  metadata {
    name      = format("%s-deploy", var.name)
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/component"  = var.component
      "app.kubernetes.io/managed-by" = "terraform"
      "app.kubernetes.io/version"    = var.tiller_version
    }
  }

  spec {
    replicas = var.tiller_replicas

    selector {
      match_labels = {
        app  = local.app
        name = var.name
      }
    }

    template {
      metadata {
        labels = {
          app  = local.app
          name = var.name
        }
      }

      spec {
        service_account_name = var.name

        container {
          name              = var.name
          image             = var.tiller_image
          image_pull_policy = "IfNotPresent"

          port {
            name           = "tiller"
            container_port = 44134
          }

          port {
            name           = "http"
            container_port = 44135
          }

          env {
            name  = "TILLER_NAMESPACE"
            value = var.namespace
          }

          env {
            name  = "TILLER_HISTORY_MAX"
            value = var.tiller_max_history
          }

          liveness_probe {
            http_get {
              path = "/liveness"
              port = 44135
            }

            initial_delay_seconds = 1
            timeout_seconds       = 1
          }

          readiness_probe {
            http_get {
              path = "/readiness"
              port = 44135
            }

            initial_delay_seconds = 1
            timeout_seconds       = 1
          }

          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = kubernetes_service_account.tiller.default_secret_name
            read_only  = true
          }
        }

        volume {
          name = kubernetes_service_account.tiller.default_secret_name

          secret {
            secret_name = kubernetes_service_account.tiller.default_secret_name
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service_account.tiller,
    kubernetes_cluster_role_binding.tiller,
  ]
}

#-----------------#
# Service Exposed #
#-----------------#
resource kubernetes_service tiller {
  metadata {
    labels = {
      "app.kubernetes.io/name"       = var.name
      "app.kubernetes.io/component"  = var.component
      "app.kubernetes.io/managed-by" = "terraform"
    }

    name      = format("%s-deploy", var.name)
    namespace = var.namespace
  }

  spec {
    port {
      name        = "tiller"
      port        = 44134
      target_port = "tiller"
    }

    selector = {
      app  = local.app
      name = var.name
    }

    type = var.tiller_service_type
  }

  depends_on = [
    kubernetes_service_account.tiller,
    kubernetes_cluster_role_binding.tiller,
    kubernetes_deployment.tiller,
  ]
}
