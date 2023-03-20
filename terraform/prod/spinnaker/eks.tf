locals {
  sso_users = {
    aws-sso-admins : "AWSReservedSSO_AdministratorAccess_0e24f3ac0c6d48da"
  }
}

module "cluster" {
  source = "../../modules/eks/v1"

  name = "spinnaker-prod"

  public_nodes_desired_size    = 4
  public_nodes_max_size        = 4
  public_nodes_release_version = "1.22.17-20230304"
  public_nodes_instance_tags = {
    "Team"  = "SRE"
    "Infra" = "prod"
    "Plane" = "SRE"
  }

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  eks_ip_family   = "ipv6"

  vpc_id             = data.aws_vpc.this.id
  private_subnet_ids = [for k, v in data.aws_subnet.private : v.id]
  public_subnet_ids  = [for k, v in data.aws_subnet.public : v.id]
}

module "eks_auth" {
  source = "../../modules/eks-auth/v1"

  eks_cluster_name = module.cluster.eks_cluster_name
  node_roles       = [module.cluster.eks_node_group_role_arn]
  sso_users        = local.sso_users
}
