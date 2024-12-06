locals {
    ## CONDITIONS
    #   Configuration object containing boolean calculations that correspond
    #       to different deployment configurations.
    conditions                              = {
        provision_bucket                    = var.s3 == null
        provision_key                       = var.kms == null
    }

    ## CLOUDFRONT DEFAULTS
    #   These are platform defaults and should only be changed when the 
    #       platform itself changes.
    platform_defaults                       = {
        cache_policy                        = "Managed-CachingOptimized"
        enabled                             = true
        default_cache_behavior              = {
            default_ttl                     = 3600
            min_ttl                         = 0
            max_ttl                         = 86400
            viewer_protocol_policy          = "redirect-to-https"
        }
        http_version                        = "http2"
        is_ipv6_enabled                     = true
        logging_config                      = {
            include_cookies                 = false
            prefix                          = "dist"
        }
        price_class                         = "PriceClass_100"
        response_headers_policy             = "Managed-SecurityHeadersPolicy"
        ssl_protocol_version                = "TLSv1.2_2021"
        viewer_certificate                  = {
            cloudfront_default_certificate  = false
            ssl_support_method              = "sni-only"
            minimum_protocol_version        = "TLSv1.2_2021"
        }
        restrictions                        = {
            geo_restriction                 = {
                locations                   = []
                restriction_type            = "none"
            }
        }
    }
    
    ## CALCULATED PROPERTIES
    #   Properties that change based on deployment configurations
    kms                                 = local.conditions.provision_key ? (
                                            module.kms[0].key 
                                        ) : var.kms
    
    s3                                  = local.conditions.provision_bucket ? (
                                            module.web_bucket[0].bucket 
                                        ) : var.s3

    logging_config                      = {
        bucket                          = join(".", [
                                            module.log_bucket.bucket[0].id,
                                            "s3",
                                            "amazonaws",
                                            "com"
                                        ])
    }
    
    origin_access_identity              = {
        comment                         = "${title(var.cdn.name)} Cloudfront Origin Access Identity"
    }

    platform                            = merge({
        # SERVICE SPECIFIC PLATFORM ARGS GO HERE, IF ANY.
    }, var.platform)
    
    tags                                = merge({
        # TODO: service specific tags go here
    }, module.platform.tags)


}