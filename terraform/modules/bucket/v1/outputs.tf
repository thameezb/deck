output "arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket" {
  value = aws_s3_bucket.this.bucket
}
output "region" {
  value = aws_s3_bucket.this.region
}
