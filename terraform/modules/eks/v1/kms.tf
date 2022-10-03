resource "aws_kms_key" "this" {
  description         = "KMS key for cluster encryption: ${var.name}"
  enable_key_rotation = true
}
