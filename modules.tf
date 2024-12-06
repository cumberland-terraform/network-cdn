module "platform" {
  source                = "github.com/cumberland-terraform/platform"

  platform              = var.platform
  
  hydration             = {
    vpc_query           = false
    subnets_query       = false
    public_sg_query     = false
    private_sg_query    = false
    eks_ami_query       = false
  }
}
