module "platform" {
  source                = "github.com/cumberland-terraform/platform"

  platform              = var.platform
  
  hydration             = {
    acm_cert_query      = true
  }

  configuration         = {
    domain_name         = "TODO"
  }
}
