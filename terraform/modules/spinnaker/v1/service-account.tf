resource "kubernetes_service_account" "this" {
  metadata {
    name      = "spinnaker"
    namespace = local.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "spinnaker@admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    namespace = local.namespace
    name      = "spinnaker"
  }
}
