resource "aws_iam_role" "this" {
  count = var.create_iam ? 1 : 0

  assume_role_policy = data.aws_iam_policy_document.assume.json
  name               = "eks_external_secret"
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.create_iam ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

data "aws_iam_role" "this" {
  count = var.create_iam ? 0 : 1

  name = "eks_external_secret"
}
