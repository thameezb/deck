resource "kubernetes_service_account_v1" "front50" {
  metadata {
    name      = "spin-terraformer-sa"
    namespace = "spinnaker"

    annotations = {
      "eks.amazonaws.com/role-arn" = var.spinnaker_irsa_assume_role_arn
    }
    labels = {
      app = "spin-terraformer-sa"
    }
  }
}
