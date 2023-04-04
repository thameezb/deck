resource "aws_s3_bucket" "spinnaker_poc" {
  bucket = local.bucket_name

  tags = {
    "Name" = local.bucket_name
  }
  tags_all = {
    "Name" = local.bucket_name
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "spinnaker_poc" {
  bucket = aws_s3_bucket.spinnaker_poc.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# Enables server side encryption on the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "spinnaker_poc" {
  bucket = aws_s3_bucket.spinnaker_poc.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

# Enables public access block on the bucket
resource "aws_s3_bucket_public_access_block" "spinnaker_poc" {
  bucket                  = aws_s3_bucket.spinnaker_poc.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
