output "eks_cluster_name" {
  value = module.cluster.eks_cluster_name
}

output "spinnaker_irsa_role_arn" {
  value = aws_iam_role.spinnaker_irsa_role.arn
}

output "spinnaker_deployment_role_arn" {
  value = aws_iam_role.spinnaker_deployment.arn
}
