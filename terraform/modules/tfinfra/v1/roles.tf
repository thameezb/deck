resource "aws_iam_role" "this" {
  name               = "terraform-backend"
  description        = "Allows access to all Terraform states"
  assume_role_policy = data.aws_iam_policy_document.backend-assume.json
}

resource "aws_iam_role_policy" "this" {
  name   = "terraform-backend"
  policy = data.aws_iam_policy_document.iam-role-policy.json
  role   = "terraform-backend"

  depends_on = [aws_iam_role.this]
}
