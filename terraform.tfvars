region = "ap-southeast-1"


vpc_config ={
    vpc_name = "my_vpc"
    vpc_cidr = "10.0.0.0/16"
    public_cidr = "10.0.1.0/24"
    private_cidr =  "10.0.11.0/24"
    accessip = "0.0.0.0/0" 
    availability_zone_ap_south_1 = "sp-southeast-1" 
}