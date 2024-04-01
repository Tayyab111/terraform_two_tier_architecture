provider "aws" {

  region = var.region
}
module "vpc" {
  source = "./vpc"
  vpc_config = {
     default = {}
  }
}