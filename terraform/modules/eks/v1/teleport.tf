module "teleport" {
  source = "git::ssh://git@github.com/yadc-io/mdb-controlplane.git//terraform/modules/infra/k8s/v2/teleport?ref=c11e05f7cb267e9ed0de70da4fbb8da33ba8dd78"

  count = var.teleport.enabled ? 1 : 0

  app_version        = var.teleport.version
  chart_version      = var.teleport.chart_version
  cluster_name       = var.teleport.cluster_name
  account_id         = var.teleport.account_id
  region_name        = var.teleport.region_name
  installation       = var.teleport.installation
  openid_cluster_arn = aws_iam_openid_connect_provider.cluster.arn
  openid_cluster_url = aws_iam_openid_connect_provider.cluster.url
  dbs                = var.teleport.dbs
  apps               = var.teleport.apps
  ec2                = var.teleport.ec2
}
