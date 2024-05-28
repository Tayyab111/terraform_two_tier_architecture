
module "vpc" {
  source     = "./vpc"
  vpc_config = var.vpc_config
  tags       = var.tags
}
module "sg" {
  for_each  = var.sg
  source    = "./sg"
  sg_config = each.value
  vpc_id    = module.vpc.vpc_id
  tags      = var.tags
}
output "subnet" {
  value = module.vpc.subnet_ids
}
output "endpont" {
  value = module.rds.cluster_endpoint
}
module "rds" {
  source = "./rds"
  #db_instance = var.db_instance
  rds_cluster = var.rds_cluster
  subnet_ids  = module.vpc.subnet_ids
  sg_id       = [module.sg["db_sg"].sg_id]
  tags        = var.tags

}
module "asg" { 
  source           = "./asg"
  tags             = var.tags 
  lanuch_template_output = module.launch_template.lanuch_template_output
  my_asg = var.my_asg
  public_subnet_id = module.vpc.public_subnet_id
  alb_target_arn = module.alb.alb_target_group_arn

 } 
module "launch_template" {
  source = "./lanuch_template"
  cluster_endpoint = module.rds.cluster_endpoint
  db_name          = module.rds.db_name
  master_username  = module.rds.user_name
  master_password  = module.rds.password
  tags             = var.tags
  launch_template = var.launch_template
  public_subnet_id = module.vpc.public_subnet_id
  sg_id = [module.sg["web_sg"].sg_id]

}
module "alb" {
  source = "./alb"
  alb = var.alb 
  tags = var.tags
  sg_id = [module.sg["web_sg"].sg_id]
  public_subnet_id = module.vpc.public_subnet_id
  vpc_id = module.vpc.vpc_id
  alb_tg = var.alb_tg
}

######################################################
# module "instance" {                                #
#   source           = "./instance"                  #
#   subnet_ids       = module.vpc.subnet_ids         #
#   sg_id            = module.sg["web_sg"].sg_id     #
#   public_subnet_id = module.vpc.public_subnet_id   #
#   tags             = var.tags                      #
#   cluster_endpoint = module.rds.cluster_endpoint   #
#   db_name          = module.rds.db_name            #
#   master_username  = module.rds.user_name          #
#   master_password  = module.rds.password           #
# }                                                  #
######################################################