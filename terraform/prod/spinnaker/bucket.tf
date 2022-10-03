module "bucket" {
  source             = "../../modules/bucket/v1"
  bucket_name_prefix = "spin-storage"
  aws_principals = [
    "arn:aws:iam::022615369514:user/spinnaker",
    "arn:aws:iam::022615369514:root",
  ]
}
