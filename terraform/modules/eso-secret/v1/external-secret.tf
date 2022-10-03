resource "kubernetes_manifest" "this" {
  manifest = {
    apiVersion = "external-secrets.io/v1beta1"
    kind       = "ExternalSecret"
    metadata = {
      name      = var.name
      namespace = var.namespace
    }
    spec = {
      refreshInterval = "1m"
      secretStoreRef = {
        name = var.secret_store_name
        kind = "SecretStore"
      }
      target = {
        name           = var.name
        creationPolicy = "Owner"
      }
      data = var.data
    }
  }
}
