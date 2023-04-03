resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_role_arn   = aws_iam_role.k8s_node_group.arn
  subnet_ids      = var.node_subnet_ids
  release_version = var.node_release_version
  instance_types  = var.instance_types

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  launch_template {
    id      = var.create_launch_template ? aws_launch_template.this[0].id : data.aws_launch_template.this[0].id
    version = var.create_launch_template ? aws_launch_template.this[0].latest_version : data.aws_launch_template.this[0].latest_version
  }

  # retaining for backward compatibility, however this should be dropped once we migrate to all private nodes 
  labels = {
    "vpc-type" = var.node_vpc_type
  }

  lifecycle {
    create_before_destroy = true
  }
}

# https://github.com/aws/containers-roadmap/issues/1723
resource "aws_launch_template" "this" {
  count = var.create_launch_template ? 1 : 0

  name                   = "eks-node-group"
  vpc_security_group_ids = [aws_security_group.node.id]

  tag_specifications {
    resource_type = "instance"
    tags          = var.node_instance_tags
  }

  private_dns_name_options {
    hostname_type = "ip-name"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "enabled"
    http_put_response_hop_limit = 3
  }
}

data "aws_launch_template" "this" {
  count = var.create_launch_template ? 0 : 1

  name = "eks-node-group"
}
