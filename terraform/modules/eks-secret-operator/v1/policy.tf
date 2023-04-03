resource "aws_iam_policy" "this" {
  count = var.create_iam ? 1 : 0

  policy = data.aws_iam_policy_document.sa.json
}

data "aws_iam_policy_document" "sa" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds",
    ]
    resources = ["arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:*"]
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
        "system:serviceaccount:external-secrets:external-secrets",
      ]
    }
    principals {
      identifiers = [var.eks_oidc_arn]
      type        = "Federated"
    }
  }
}
