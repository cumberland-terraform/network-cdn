variable "platform" {
  description               = "Platform metadata object."
  type                      = object({
    client                  = string
    environment             = string
  })

}

variable "s3" {
  description                   = "S3 Bucket configuration object. If not provided, a bucket will be provisioned."
  type                          = object({
    bucket_regional_domain_name = string
    id                          = string 
  })
  default                       = null
}

variable "kms" {
  description                   = "KMS Key configuration object. If not provided, a key will be provisioned. An AWS managed key can be used by specifying `aws_managed = true`."
  type                          = object({
    aws_managed                 = optional(bool, false)
    id                          = optional(string, null)
    arn                         = optional(string, null)
    alias_arn                   = optional(string, null)
  })
  default                       = null
}

variable "cdn" {
  description                   = "Cloudfront Distribution configuration object."
  type                          = object({
    domain                      = string
    name                        = string
    default_root_object         = optional(string, "index.html")
    allowed_methods             = optional(list(string), [ 
                                    "GET", 
                                    "HEAD", 
                                    "OPTIONS"
                                ])
    cached_methods              = optional(list(string), [
                                    "GET",
                                    "HEAD"
                                ])
  })
}