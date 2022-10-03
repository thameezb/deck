data "aws_iam_policy_document" "kms" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.aws_principals
    }
    resources = ["*"]
    actions   = ["kms:*"]
  }
}

data "aws_iam_policy_document" "s3" {
  statement {
    sid     = "Allow to use s3"
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      format("%s", aws_s3_bucket.this.arn),
      format("%s/*", aws_s3_bucket.this.arn)
    ]
    principals {
      type        = "AWS"
      identifiers = var.aws_principals
    }
  }
}
