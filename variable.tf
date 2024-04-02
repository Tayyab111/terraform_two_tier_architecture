variable "region" {

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 358ff418bb36b16fa269d33347d2c41a50aec6f0
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
<<<<<<< HEAD
=======
} 
>>>>>>> 5c0d807 (new2)
=======
>>>>>>> 358ff418bb36b16fa269d33347d2c41a50aec6f0
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