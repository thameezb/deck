locals {
  cluster_name = "spinnaker-terraformer-poc"

  secret_store_name = "${local.cluster_name}-aws-secrets"
}
