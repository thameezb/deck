locals {
  cluster_name           = "spinnaker-terraformer-poc"
  secret_store_name      = "${local.cluster_name}-aws-secrets"
  bucket_name            = "armory-spinnaker-storage"
  operator_k8s_namespace = "spinnaker-operator"
}
