data "aws_iam_group" "this" {
  group_name = each.key
  for_each   = { for group in var.map_groups : group.iam_group_name => group }
}

locals {
  map_roles = concat(
    [
      for role in var.node_roles : {
        rolearn  = role
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ],
    [
      for map_role in var.map_roles : {
        rolearn  = map_role.iam_role
        username = map_role.username
        groups   = try(map_role.groups, [])
      }
    ]
  )
  map_users = flatten(concat(
    [
      for map_user in var.map_users : {
        userarn  = map_user.iam_user
        username = map_user.username
        groups   = try(map_user.groups, [])
      }
      ], [
      for group in var.map_groups : [
        for user in data.aws_iam_group.this[group.iam_group_name].users : {
          userarn  = user.arn
          username = user.user_name
          groups   = try(group.groups, [])
        }
      ]
  ]))
  map_accounts = var.map_accounts
}


resource "kubernetes_config_map_v1_data" "aws_auth" {
  force = true
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles    = yamlencode(local.map_roles)
    mapUsers    = yamlencode(local.map_users)
    mapAccounts = yamlencode(local.map_accounts)
  }
}
