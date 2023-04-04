resource "kubernetes_namespace" "spinnaker_operator" {
  metadata {
    name = local.operator_k8s_namespace
    annotations = {
      name = local.operator_k8s_namespace
    }
    labels = {
      app = local.operator_k8s_namespace
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "kubernetes_namespace" "spinnaker" {
  metadata {
    name = "spinnaker"
    annotations = {
      name = "spinnaker"
    }
    labels = {
      app = "spinnaker"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

# resource "helm_release" "armory_spinnaker_operator" {
#   name              = "armory-spinnaker-operator"
#   repository        = "https://armory.jfrog.io/artifactory/charts"
#   chart             = "armory-spinnaker-operator"
#   version           = "1.8.4"
#   namespace         = kubernetes_namespace.spinnaker_operator.metadata[0].annotations.name
#   dependency_update = true
#   atomic            = false
#   cleanup_on_fail   = true
#   create_namespace  = true
#   reset_values      = true
#   wait              = true
#   values = [templatefile("${path.module}/files/values.tpl.yaml", {
#     spinnaker_backend_bucket_name  = aws_s3_bucket.spinnaker_poc.bucket
#     spinnaker_deployment_namespace = kubernetes_namespace.spinnaker.metadata[0].annotations.name
#     armorycd_version               = var.armorycd_version
#     front50_service_account_name   = "spin-front50"
#   })]
# }

# # resource "kubernetes_manifest" "armory_account_crd" {
# #   manifest = yamldecode(file("${path.module}/files/crd/spinnaker.armory.io_armoryaccounts.yaml"))
# # }

# # resource "kubernetes_manifest" "spinnaker_service_crd" {
# #   manifest = yamldecode(file("${path.module}/files/crd/spinnaker.armory.io_spinnakerservices.yaml"))
# # }

# # resource "kubernetes_manifest" "operator_cluster_service_account" {
# #   manifest = yamldecode(file("${path.module}/files/cluster/service_account.yaml"))
# # }

# # resource "kubernetes_manifest" "operator_cluster_halyard_configmap" {
# #   manifest = yamldecode(file("${path.module}/files/cluster/halyard_config_map.yml"))
# # }

# # resource "kubernetes_manifest" "operator_cluster_halyard_role_binding" {
# #   manifest = yamldecode(file("${path.module}/files/cluster/role_binding.yaml"))
# # }

# # resource "kubernetes_manifest" "operator_cluster_halyard_role" {
# #   manifest = yamldecode(file("${path.module}/files/cluster/role.yaml"))
# # }

# # resource "kubernetes_manifest" "operator_cluster_deployment" {
# #   manifest = yamldecode(file("${path.module}/files/cluster/deployment.yaml"))
# # }

