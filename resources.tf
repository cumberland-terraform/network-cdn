resource "aws_cloudfront_origin_access_identity" "this" {
    comment                             = local.origin_access_identity.comment
}

resource "aws_cloudfront_distribution" "this" {
    aliases                             = [ var.cdn.domain ]
    default_root_object                 = var.distribution.default_root_object
    enabled                             = local.platform_defaults.enabled
    http_version                        = local.platform_defaults.http_version
    is_ipv6_enabled                     = local.platform_defaults.is_ipv6_enabled
    price_class                         = local.platform_defaults.price_class

    origin {
        domain_name                     = local.s3.bucket_regional_domain_name
        origin_id                       = var.cdn.name

        s3_origin_config {
            origin_access_identity      = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
        }
    }

    logging_config {
        include_cookies                 = local.platform_defaults.logging_config.include_cookies
        bucket                          = module.log_bucket.bucket[0].id
        prefix                          = local.platform_defaults.logging_config.prefix
    }

    default_cache_behavior {
        allowed_methods                 = var.distribution.allowed_methods
        cached_methods                  = var.distribution.cached_methods
        cache_policy_id                 = data.aws_cloudfront_cache_policy.this.id
        default_ttl                     = local.platform_defaults.default_cache_behavior.default_ttl
        min_ttl                         = local.platform_defaults.default_cache_behavior.min_ttl
        max_ttl                         = local.platform_defaults.default_cache_behavior.max_ttl
        response_headers_policy_id      = data.aws_cloudfront_response_headers_policy.this.id
        target_origin_id                = var.cdn.name
        viewer_protocol_policy          = local.platform_defaults.default_cache_behavior.viewer_protocol_policy
        }

    viewer_certificate {
        acm_certificate_arn             = data.aws_acm_certificate.domain.arn
        cloudfront_default_certificate  = local.platform_defaults.viewer_certificate.cloudfront_default_certificate
        minimum_protocol_version        = local.platform_defaults.viewer_certificate.ssl_protocol_version
        ssl_support_method              = local.platform_defaults.viewer_certificate.ssl_support_method
    }

    restrictions {
      geo_restriction {
        locations                       = local.platform_defaults.restrictions.geo_restriction.locations
        restriction_type                = local.platform_defaults.restrictions.geo_restriction.restriction_type
      }
    }
}