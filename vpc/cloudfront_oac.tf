resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "s3-oac"
  description                       = "OAC for CloudFront to access S3"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
