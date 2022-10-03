resource "kubernetes_namespace" "this" {
  metadata {
    name = var.k8s_namespace
    labels = {
      app = "spin"
    }
  }



  lifecycle {
    prevent_destroy = true
  }
}
