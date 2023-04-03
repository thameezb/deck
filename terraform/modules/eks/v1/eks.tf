resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = aws_iam_role.k8s_master.arn
  version  = "1.22"

  encryption_config {
    resources = ["secrets"]
    provider { key_arn = aws_kms_key.this.arn }
  }

  vpc_config {
    # retaining due to backward compatibility, this should refer to just var.node_subnet_ids
    subnet_ids              = concat(var.private_subnet_ids, var.node_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.cluster.id]
  }

  kubernetes_network_config {
    ip_family = var.eks_ip_family
  }

  enabled_cluster_log_types = [
    "authenticator"
  ]
}
