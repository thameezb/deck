output "eks_cluster_name" {
  value = module.cluster.eks_cluster_name
}

output "spinnaker_irsa_role_arn" {
  value = aws_iam_role.spinnaker_irsa_role.arn
}

output "spinnaker_assumable_multiaccount_deployment_arn" {
  value = aws_iam_role.spinnaker_assumable_multiaccount_deployment.arn
}
