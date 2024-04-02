variable "region" {

<<<<<<< HEAD
}
# variable "vpc_name" {
  
# }
# variable "vpc_cidr" {
  
# }
# variable "public_cidrs" {
  
# }
# variable "private_cidrs" {
  
# }
# variable "availability_zones_ap_south_1" {
  
# }
# variable "accessip" {
  
# }
=======
} 
>>>>>>> 5c0d807 (new2)
variable "vpc_config" {
  type = object({
    #region    = "ap-south-1"
    vpc_name                      = string
    vpc_cidr                      = string
    public_cidrs                  = string
    private_cidrs                 = string
    availability_zones_ap_south_1 = string
    accessip                      = string
  })
  
}