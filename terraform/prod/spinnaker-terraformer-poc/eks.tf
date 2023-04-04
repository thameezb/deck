locals {
  sso_users = {
    aws-sso-admins : "AWSReservedSSO_AdministratorAccess_0e24f3ac0c6d48da"
  }
}

module "cluster" {
  source = "../../modules/eks/v1"

  name               = local.cluster_name
  kubernetes_version = "1.25"
  # required due to backward compatibility, this should be removed
  node_vpc_type        = "private"
  node_desired_size    = 3
  node_max_size        = 5
  node_release_version = "1.25.7-20230322"
  node_instance_tags = {
    "Team"  = "SRE"
    "Infra" = "preprod"
    "Plane" = "SRE"
  }

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  eks_ip_family   = "ipv4"

  vpc_id                 = data.aws_vpc.this.id
  node_subnet_ids        = [for k, v in data.aws_subnet.private : v.id]
  create_iam             = false
  create_launch_template = false
}
