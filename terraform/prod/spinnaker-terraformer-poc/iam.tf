resource "kubernetes_service_account_v1" "front50" {
  metadata {
    name      = "spin-front50"
    namespace = "spinnaker"

    annotations = {
      "eks.amazonaws.com/role-arn" = module.spinnaker_poc_irsa.iam_role_arn
    }

    labels = {
      app = "spin-front50"
    }
  }
}

data "aws_iam_policy_document" "spinnaker_poc" {
  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.spinnaker_poc.arn}",
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.spinnaker_poc.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "spinnaker_poc" {
  name   = "spinnaker_poc"
  policy = data.aws_iam_policy_document.spinnaker_poc.json
}


module "spinnaker_poc_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.14"

  role_name = "spinnaker_poc"
  role_policy_arns = {
    policy = aws_iam_policy.spinnaker_poc.arn
  }

  oidc_providers = {
    main = {
      provider_arn               = module.cluster.eks_oidc_arn
      namespace_service_accounts = ["spinnaker:default", "spinnaker-operator:spinnaker-operator"]
    }
  }
}
