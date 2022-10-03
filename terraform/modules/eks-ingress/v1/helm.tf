# resource "helm_release" "ingress_nginx_external" {
#   name              = local.public_ingress_ns
#   repository        = "https://kubernetes.github.io/ingress-nginx"
#   chart             = "ingress-nginx"
#   namespace         = local.public_ingress_ns
#   version           = "4.2.5"
#   dependency_update = true
#   atomic            = true
#   cleanup_on_fail   = true
#   create_namespace  = true
#   reset_values      = true
#   wait              = true
#   values = [
#     templatefile("${path.module}/files/config.tpl.yaml", {
#       service_account_iam_role_arn = aws_iam_role.this.arn
#       acm_arn                      = var.acm_arn
#       tags = merge({
#         eks-ingress-ns   = local.public_ingress_ns
#         eks-ingress-type = "public"
#       }, var.tags)
#     })
#   ]
#   depends_on = [
#     aws_iam_role_policy_attachment.this
#   ]
# }

resource "helm_release" "elb" {
  name              = "eks-elb"
  repository        = "https://aws.github.io/eks-charts"
  chart             = "aws-load-balancer-controller"
  namespace         = "kube-system"
  version           = "1.4.4"
  dependency_update = true
  atomic            = true
  cleanup_on_fail   = true
  create_namespace  = true
  reset_values      = true
  wait              = true
  values = [
    templatefile("${path.module}/files/elb.config.tpl.yaml", {
      service_account_iam_role_arn = aws_iam_role.this.arn
      cluster_name                 = var.cluster_name
      region                       = var.region
      vpc_id                       = var.vpc_id
    })
  ]
  depends_on = [
    aws_iam_role_policy_attachment.this
  ]
}
