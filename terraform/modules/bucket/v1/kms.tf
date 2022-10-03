resource "aws_kms_key" "this" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = var.kms_deletion_window_in_days
  enable_key_rotation     = true

  policy = data.aws_iam_policy_document.kms.json

  tags = {
    "Name" = local.name
  }
  tags_all = {
    "Name" = local.name
  }

  lifecycle {
    prevent_destroy = true
  }
}
