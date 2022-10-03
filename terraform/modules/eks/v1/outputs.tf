// Cluster Info
output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}
output "eks_endpoint_url" {
  value = aws_eks_cluster.this.endpoint
}
output "eks_cluster_id" {
  value = aws_eks_cluster.this.id
}
output "eks_node_group_ids" {
  value = [
    aws_eks_node_group.public.id,
  ]
}
output "eks_ca_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "kms" {
  value = aws_kms_key.this.arn
}

// Roles
output "eks_node_group_role_arn" {
  value = aws_iam_role.k8s_node_group.arn
}
output "eks_master_role_arn" {
  value = aws_iam_role.k8s_master.arn
}

// OIDC
output "eks_oidc_url" {
  value = aws_iam_openid_connect_provider.cluster.url
}
output "eks_oidc_arn" {
  value = aws_iam_openid_connect_provider.cluster.arn
}
output "eks_oidc_client_id" {
  value = aws_iam_openid_connect_provider.cluster.client_id_list
}
