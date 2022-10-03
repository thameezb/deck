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

data "aws_iam_policy_document" "backend-assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = var.aws_principals
    }
  }
}

data "aws_iam_policy_document" "iam-role-policy" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [format("%s", aws_s3_bucket.this.arn), ]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = [format("%s/*", aws_s3_bucket.this.arn), ]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = ["arn:aws:dynamodb:*:*:table/terraform-lock"]
  }

  statement {
    actions   = ["kms:*"]
    resources = [aws_kms_key.this.arn]
  }
}
