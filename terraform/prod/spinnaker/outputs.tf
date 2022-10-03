output "eks_cluster_name" {
  value = module.cluster.eks_cluster_name
}
output "eks_endpoint_url" {
  value = module.cluster.eks_endpoint_url
}
output "eks_cluster_id" {
  value = module.cluster.eks_cluster_id
}
output "eks_node_group_ids" {
  value = module.cluster.eks_node_group_ids
}
output "eks_ca_data" {
  value = module.cluster.eks_ca_data
}
output "kms" {
  value = module.cluster.kms
}

output "bucket" {
  value = module.bucket.bucket
}

output "eks_oidc_url" {
  value = module.cluster.eks_oidc_url
}
output "eks_oidc_arn" {
  value = module.cluster.eks_oidc_arn
}
output "eks_oidc_client_id" {
  value = module.cluster.eks_oidc_client_id
}
