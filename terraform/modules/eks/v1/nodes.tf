resource "aws_eks_node_group" "public" {
  cluster_name  = aws_eks_cluster.this.name
  node_role_arn = aws_iam_role.k8s_node_group.arn
  subnet_ids    = var.public_subnet_ids
  scaling_config {
    desired_size = var.public_nodes_desired_size
    max_size     = var.public_nodes_max_size
    min_size     = var.public_nodes_min_size
  }

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version
  }
  labels = {
    "vpc-type" = "public"
  }
}

# https://github.com/aws/containers-roadmap/issues/1723
resource "aws_launch_template" "this" {
  name = "eks-node-group"

  vpc_security_group_ids = [aws_security_group.node.id]
  private_dns_name_options {
    hostname_type = "ip-name"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "enabled"
    http_put_response_hop_limit = 3
  }
}
