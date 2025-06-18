module "platform" {
  # META ARGUMENTS
  source                        = "github.com/cumberland-terraform/platform.git"
  # PLATFORM ARGUMENTS
  platform                      = local.platform
  # MODULE ARGUMENTS
  hydration                     = {
    acm_cert_query              = true
  }
  configuration                 = {
    domain_name                 = var.cdn.aliases[0]
  }
}

module "kms" {
  # META ARGUMENTS
  count                         = local.conditions.provision_key ? 1 : 0
  source                        = "github.com/cumberland-terraform/security-kms.git"
  # PLATFORM ARGUMENTS
  platform                      = local.platform
  # MODULE ARGUMENTS
  kms                           = {
      alias_suffix              = var.cdn.name
  }
}

module "web_bucket" {
  # META ARGUMENTS
  count                         = local.conditions.provision_bucket ? 1 : 0
  source                        = "github.com/cumberland-terraform/storage-s3.git"
  # PLATFORM ARGUMENTS
  platform                      = local.platform
  # MODULE ARGUMENTS
  kms                           = local.kms
  s3                            = {
    purpose                     = "Static web content for ${var.cdn.name} CDN"
    suffix                      = var.cdn.name
    website_configuration       = {
        enabled                 = true
    } 
  }
}

module "log_bucket" {
  # META ARGUMENTS
  source                        = "github.com/cumberland-terraform/storage-s3.git"
  # PLATFORM ARGUMENTS
  platform                      = local.platform
  # MODULE ARGUMENTS
  kms                           = local.kms
  s3                            = {
    purpose                     = "Logs for ${var.cdn.name} CDN"
    suffix                      = join("-", [var.cdn.name, "cdn","logs"])
    public_access_block         = {
      block_public_acls         = false
      block_public_policy       = false
      ignore_public_acls        = false
      restrict_public_buckets   = false
    }
  }
}