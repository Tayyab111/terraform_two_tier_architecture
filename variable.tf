variable "region" {

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
variable "vpc_config" {
  type = map(any)

  default = ({
    #region    = "ap-south-1"
    vpc_name                      = "custom-vpc"
    vpc_cidr                      = "10.0.0.0/16"
    public_cidrs                  = "10.0.1.0/24"
    private_cidrs                 = "10.0.11.0/24"
    availability_zones_ap_south_1 = "ap-south-1a"
    accessip                      = "0.0.0.0/0"
  })
}