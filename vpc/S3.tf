resource "aws_s3_bucket" "cf_origin" {
  bucket = "my-prod-cdn-origin-${random_id.suffix.hex}"

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "cf_origin" {
  bucket = aws_s3_bucket.cf_origin.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_id" "suffix" {
  byte_length = 4
}
