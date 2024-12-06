
data "aws_cloudfront_cache_policy" "this" {
  name                      = local.platform_defaults.cache_policy
}

data "aws_cloudfront_response_headers_policy" "this" {
  name                      = local.platform_defaults.response_headers_policy
}

data "aws_iam_policy_document" "this" {
  statement {
    sid                     = "EnableCloudfrontAccess"
    effect                  = "Allow"
    actions                 = [ "s3:GetObject" ]
    resources               = [ 
                                local.s3.arn,
                                "${local.s3.arn}/*"
                            ]

    principals {
      type                  =  "CanonicalUser"
      identifiers           = [
                                aws_cloudfront_origin_access_identity.this.s3_canonical_user_id
                            ]
    }
  }
}