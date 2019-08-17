resource kubernetes_service_account tiller {
  metadata {
    name      = var.name
    namespace = var.namespace

    labels = {
      "app.kubernetes.io/name"       = var.namespace
      "app.kubernetes.io/component"  = var.name
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  automount_service_account_token = var.automount_service_account_token
}