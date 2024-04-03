variable "vpc_config" {
    type = object({
      vpc_name = string
      vpc_cidr = string
      public_cidr = string
      private_cidr =  string
      accessip = string
      availability_zone_ap_south_1 = string
    })
  
}