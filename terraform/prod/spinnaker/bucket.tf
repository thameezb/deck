module "bucket" {
  source             = "../../modules/bucket/v1"
  bucket_name_prefix = "spin-storage"
  aws_principals = [
    "arn:aws:iam::022615369514:user/spinnaker",
    "arn:aws:iam::022615369514:root",
  ]
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
