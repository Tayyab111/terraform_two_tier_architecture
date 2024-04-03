provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./vpc"
  vpc_config = {
    vpc_name                      = "my_vpc"
    vpc_cidr                      = "10.0.0.0/16"
    public_cidr                  = "10.0.1.0/24"
    private_cidr                 = "10.0.11.0/24"
    availability_zone_ap_south_1 = "ap-south-1a"
    accessip                      = "0.0.0.0/0"
  }
}