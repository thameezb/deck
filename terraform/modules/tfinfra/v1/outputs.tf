output "bucket" {
  value = {
    arn    = aws_s3_bucket.this.arn
    domain = aws_s3_bucket.this.bucket_domain_name
  }
}

output "state_role" {
  value = aws_iam_role.this.arn
}
