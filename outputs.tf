output "cdn" {
    description         = "Metadata for CDN"
    value               = {
        hosted_zone_id  = aws_cloudfront_distribution.this.hosted_zone_id
        domain_name     = aws_cloudfront_distribution.this.domain_name
    }
}