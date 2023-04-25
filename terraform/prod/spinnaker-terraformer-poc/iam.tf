data "aws_iam_policy_document" "spinnaker_irsa_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.cluster.eks_oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.cluster.eks_oidc_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.cluster.eks_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:spinnaker:spin-terraformer-sa"]
    }
  }
}

resource "aws_iam_role" "spinnaker_irsa_role" {
  name               = "SpinnakerTerraformerIRSARole"
  description        = "Assumeable Role for Spinnaker Terraformer Pods"
  assume_role_policy = data.aws_iam_policy_document.spinnaker_irsa_assume_policy.json
}

data "aws_iam_policy_document" "spinnaker_assumable_multiaccount_deployment_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [module.cluster.eks_oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.cluster.eks_oidc_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(module.cluster.eks_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:spinnaker:spin-terraformer-sa"]
    }
  }
}

data "aws_iam_policy_document" "spinnaker_assumable_multiaccount_deployment" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["*"]
  }
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    resources = [
      # dc-ch-preprod
      "arn:aws:iam::867394682372:role/SpinnakerDeploymentRole",
      # dc-ch-prod
      "arn:aws:iam::118027436691:role/SpinnakerDeploymentRole",
      # dc-mdb-preprod or common-infra-preprod-deprecated
      "arn:aws:iam::221736954043:role/SpinnakerDeploymentRole",
      # dc-mdb-preprod-ng
      "arn:aws:iam::785415555008:role/SpinnakerDeploymentRole",
      # dc-mdb-prod
      "arn:aws:iam::883433064081:role/SpinnakerDeploymentRole",
      # dc-ui-bi-preprod
      "arn:aws:iam::177770737270:role/SpinnakerDeploymentRole",
      # yadc-ydb-preprod
      "arn:aws:iam::690619578286:role/SpinnakerDeploymentRole",
      # yadc-ydb
      "arn:aws:iam::511453442829:role/SpinnakerDeploymentRole",
      # dc-infraplane-preprod
      "arn:aws:iam::260947003881:role/SpinnakerDeploymentRole",
      # dc-infraplane-prod
      "arn:aws:iam::737497888847:role/SpinnakerDeploymentRole",
      # yadc-spinnaker
      "arn:aws:iam::022615369514:role/SpinnakerDeploymentRole",
      # yadc-sre
      "arn:aws:iam::461644856699:role/SpinnakerDeploymentRole",
      # dc-common-infra-prod
      "arn:aws:iam::710586422240:role/SpinnakerDeploymentRole",
    ]
  }
}

resource "aws_iam_policy" "spinnaker_assumable_multiaccount_deployment" {
  name        = "SpinnakerAssumableDeploymentPolicy"
  description = "Policy which allows Spinnaker Terraformer to assume roles in other accounts"
  policy      = data.aws_iam_policy_document.spinnaker_assumable_multiaccount_deployment.json
}

resource "aws_iam_role" "spinnaker_assumable_multiaccount_deployment" {
  name               = "SpinnakerAssumableDeploymentRole"
  description        = "Allows Spinnaker Terraformer to assume roles in other accounts"
  assume_role_policy = data.aws_iam_policy_document.spinnaker_assumable_multiaccount_deployment_assume_policy.json
}

resource "aws_iam_role_policy_attachment" "spinnaker_assumable_multiaccount_deployment" {
  role       = aws_iam_role.spinnaker_assumable_multiaccount_deployment.name
  policy_arn = aws_iam_policy.spinnaker_assumable_multiaccount_deployment.arn
}

data "aws_iam_policy_document" "spinnaker_deployment_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.spinnaker_assumable_multiaccount_deployment.arn]
    }
  }
}

resource "aws_iam_role" "spinnaker_deployment" {
  name               = "SpinnakerDeploymentRole"
  description        = "Role for Spinnaker Deployment"
  assume_role_policy = data.aws_iam_policy_document.spinnaker_deployment_assume_role.json
}

resource "aws_iam_role_policy_attachment" "spinnaker_deployment" {
  role       = aws_iam_role.spinnaker_deployment.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
