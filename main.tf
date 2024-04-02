provider "aws" {

  region = var.region
}
module "vpc" {
  source = "./vpc"
  vpc_config = {
    vpc_name                      = "custom-vpc"
    vpc_cidr                      = "10.0.0.0/16"
    public_cidrs                  = "10.0.1.0/24"
    private_cidrs                 = "10.0.11.0/24"
    availability_zones_ap_south_1 = "ap-south-1a"
    accessip                      = "0.0.0.0/0"
  }
}