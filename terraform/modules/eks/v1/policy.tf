data "aws_iam_policy_document" "k8s_master" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "k8s_node_group" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "ipv6" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:AssignIpv6Addresses",
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeInstanceTypes"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = [
      "arn:aws:ec2:*:*:network-interface/*"
    ]
  }

}

resource "aws_iam_policy" "ipv6" {
  count = var.create_iam ? 1 : 0

  name   = "eks_ipv6"
  policy = data.aws_iam_policy_document.ipv6.json
}

data "aws_iam_policy" "ipv6" {
  count = var.create_iam ? 0 : 1

  name = "eks_ipv6"
}
