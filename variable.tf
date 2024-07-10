variable "region" {}
variable "vpc_config" {}

variable "sg" {}
variable "tags" {}


variable "rds_cluster" {}

# variable "db_instance" {

# }
variable "launch_template" {}

variable "my_asg" {}
variable "asg_scaling_policy_scale_out" {}
variable "asg_scaling_policy_scale_in" {}

variable "alb" {}
variable "alb_tg" {}

variable "cpu_utilization" {}


variable "sns_topic" {}