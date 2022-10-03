locals {
  name = var.bucket_name == "" ? var.bucket_name : var.bucket_name_prefix
}
