
variable "vpc_config" {
  type = object({
    vpc_name                      = string
    vpc_cidr                      = string
    public_cidrs                  = string
    private_cidrs                 = string
    availability_zones_ap_south_1 = string
    accessip                      = string
  })

  
}
