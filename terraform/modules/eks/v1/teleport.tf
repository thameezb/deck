module "teleport" {
  source = "git::ssh://git@github.com/yadc-io/mdb-controlplane.git//terraform/modules/infra/k8s/v2/teleport?ref=43bde30b23e80ce3d9f1d102b9fd091946ef6ebb"

  count = var.teleport.enabled ? 1 : 0

  app_version           = var.teleport.version
  chart_version         = var.teleport.chart_version
  cluster_name          = var.teleport.cluster_name
  cluster_name_override = var.teleport.cluster_name_override
  account_id            = var.teleport.account_id
  region_name           = var.teleport.region_name
  installation          = var.teleport.installation
  openid_cluster_arn    = aws_iam_openid_connect_provider.cluster.arn
  openid_cluster_url    = aws_iam_openid_connect_provider.cluster.url
  dbs                   = var.teleport.dbs
  apps                  = var.teleport.apps
  ec2                   = var.teleport.ec2
}
