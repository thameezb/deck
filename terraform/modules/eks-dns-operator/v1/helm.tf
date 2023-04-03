resource "helm_release" "external-dns" {
  name              = "external-dns"
  repository        = "https://charts.bitnami.com/bitnami"
  chart             = "external-dns"
  version           = "6.9.0"
  namespace         = "external-dns"
  dependency_update = true
  atomic            = true
  cleanup_on_fail   = true
  create_namespace  = true
  reset_values      = true
  wait              = true
  values = [templatefile("${path.module}/files/config.tpl.yaml", {
    aws_dns_public_zone_id       = var.aws_dns_public_zone_id
    service_account_iam_role_arn = var.create_iam ? aws_iam_role.this[0].arn : data.aws_iam_role.this[0].arn
  })]
}
