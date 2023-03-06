output "arn_full" {
  value = data.aws_iam_role.this.arn
}

# For K8S "aws-auth" config map (path must be removed from role)
# See https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html for details
output "arn_wo_path" {
  value = "arn:${local.partition}:${local.service}:${local.region}:${local.account}:${local.resource_type}/${local.resource_name}"
}

output "user_name" {
  value = var.user_name
}
