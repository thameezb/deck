module "cluster" {
  source = "../../modules/eks/v1"

  name = "spinnaker-prod"

  public_nodes_desired_size = 4
  public_nodes_max_size     = 4
  thumbprint_list           = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  eks_ip_family             = "ipv6"

  vpc_id             = data.aws_vpc.this.id
  private_subnet_ids = [for k, v in data.aws_subnet.private : v.id]
  public_subnet_ids  = [for k, v in data.aws_subnet.public : v.id]
}

module "eks_auth" {
  source = "../../modules/eks-auth/v1"

  eks_cluster_name = module.cluster.eks_cluster_name
  node_roles       = [module.cluster.eks_node_group_role_arn]
  map_users = [{
    groups   = ["system:masters"]
    iam_user = "arn:aws:iam::022615369514:user/salvatoremazz"
    username = "salvatoremazz"
  }]
}
