locals {
  origin_id = "s3-app-client-origin"
}

data "aws_s3_bucket" "app_client" {
  bucket = var.app_client_bucket_name
}

resource "aws_cloudfront_origin_access_identity" "this" {
  comment = "Access identity for ${data.aws_s3_bucket.app_client.bucket}"
}

data "aws_iam_policy_document" "app_bucket" {
  statement {
    sid     = "AllowCloudFrontReadObjects"
    effect  = "Allow"
    actions = ["s3:GetObject"]

    resources = ["${data.aws_s3_bucket.app_client.arn}/*"]

    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.this.s3_canonical_user_id]
    }
  }

  statement {
    sid     = "AllowCloudFrontListBucket"
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [data.aws_s3_bucket.app_client.arn]

    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.this.s3_canonical_user_id]
    }
  }
}

resource "aws_s3_bucket_policy" "app_client" {
  bucket = data.aws_s3_bucket.app_client.id
  policy = data.aws_iam_policy_document.app_bucket.json
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  # aliases             = ["walkaiorg.app", "www.walkaiorg.app"]

  origin {
    domain_name = data.aws_s3_bucket.app_client.bucket_regional_domain_name
    origin_id   = local.origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.origin_id

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:864683107176:certificate/86052bbd-79a2-4037-8ef2-b749fdf89197"
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
    cloudfront_default_certificate = false
  }

  tags = merge(
    var.tags,
    {
      Name = "walkai-web-distribution"
    }
  )

  depends_on = [
    aws_s3_bucket_policy.app_client
  ]
}
