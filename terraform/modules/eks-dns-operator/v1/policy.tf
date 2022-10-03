resource "aws_iam_policy" "this" {
  policy = data.aws_iam_policy_document.dns.json
}

data "aws_iam_policy_document" "dns" {
  version = "2012-10-17"
  statement {
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = ["arn:aws:route53:::hostedzone/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:external-dns:external-dns",
        "system:serviceaccount:external-dns:default",
      ]
    }
    principals {
      identifiers = [var.eks_oidc_arn]
      type        = "Federated"
    }
  }
}
