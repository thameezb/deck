resource "kubernetes_manifest" "this" {
  manifest = yamldecode(templatefile("./files/secret-store.tpl.yaml", {
    name      = local.secret_store_name
    namespace = local.namespace
    region    = var.region
  }))
}
