data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:${local.namespace}:spinnaker",
      ]
    }
    principals {
      identifiers = [var.eks_oidc_arn]
      type        = "Federated"
    }
  }
}
