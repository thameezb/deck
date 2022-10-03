resource "helm_release" "this" {
  name              = "external-secrets"
  repository        = "https://charts.external-secrets.io"
  chart             = "external-secrets"
  version           = "0.6.0-rc1"
  namespace         = "external-secrets"
  dependency_update = true
  atomic            = true
  cleanup_on_fail   = true
  create_namespace  = true
  reset_values      = true
  wait              = true
  values = [templatefile("${path.module}/files/config.tpl.yaml", {
    service_account_iam_role_arn = aws_iam_role.this.arn
  })]
}
