variable "platform" {
  description               = "Platform metadata object."
  type                      = object({
    client                  = string
    environment             = string
  })

}


variable "cdn" {
  description               = "Cloudfront Distribution configuration object."
  type                      = object({

  })
}