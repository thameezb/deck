resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  bucket_prefix = var.bucket_name_prefix

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

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# Ignore object's ownership inheritance from PutObject
resource "aws_s3_bucket_ownership_controls" "state" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_policy" "state" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.s3.json
}

# Enables server side encryption on the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.this.arn
      sse_algorithm     = "aws:kms"
    }
  }
  lifecycle {
    prevent_destroy = true
  }
}

# Enables public access block on the bucket
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
