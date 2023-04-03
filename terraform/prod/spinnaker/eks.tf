locals {
  sso_users = {
    aws-sso-admins : "AWSReservedSSO_AdministratorAccess_0e24f3ac0c6d48da"
  }

  k8s_cluster_name = "spinnaker-prod"

  teleport = {
    installation_labels = {
      account = "spinnaker"
      env     = "prod"
      plane   = "SRE"
    }
    cluster_name = "sre-${local.k8s_cluster_name}"
  }
}

module "cluster" {
  source = "../../modules/eks/v1"

  name = local.k8s_cluster_name

  node_desired_size    = 4
  node_max_size        = 4
  node_release_version = "1.22.17-20230304"
  node_instance_tags = {
    "Team"  = "SRE"
    "Infra" = "prod"
    "Plane" = "SRE"
  }

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
  eks_ip_family   = "ipv6"

  vpc_id          = data.aws_vpc.this.id
  node_subnet_ids = [for k, v in data.aws_subnet.public : v.id]

  # retaining due to backward compatibility, this should be removed 
  private_subnet_ids = [for k, v in data.aws_subnet.private : v.id]

  teleport = {
    cluster_name          = local.k8s_cluster_name
    cluster_name_override = local.teleport.cluster_name
    enabled               = true
    version               = "11.3.7"
    chart_version         = "12.0.0-alpha.1"
    account_id            = data.aws_caller_identity.current.account_id
    region_name           = var.region
    installation          = local.teleport.installation_labels

    # TBD
    apps = []

    dbs = [{
      type    = "rds"
      regions = ["eu-central-1"]
      tags = {
        "*" = "*"
      }
    }]

    ec2 = {
      enabled   = true
      installer = "sre-${local.teleport.installation_labels.env}"
      regions   = ["eu-central-1"]
      tags = {
        "*" = "*"
      }
    }
  }
}

module "eks_auth" {
  source = "../../modules/eks-auth/v1"

  eks_cluster_name = module.cluster.eks_cluster_name
  node_roles       = [module.cluster.eks_node_group_role_arn]
  sso_users        = local.sso_users
}
