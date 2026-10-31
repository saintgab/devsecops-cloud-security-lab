resource "aws_s3_bucket_lifecycle_configuration" "lab_bucket" {
  bucket = aws_s3_bucket.lab_bucket.id

  rule {
    id     = "cleanup-noncurrent-versions"
    status = "Enabled"

    filter {}

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}
