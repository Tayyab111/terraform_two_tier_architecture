region = "ap-southeast-1"


vpc_config = {

  vpc_name    = "my_vpc"
  vpc_cidr    = "10.0.0.0/16"
  public_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #private_cidr =  "10.0.11.0/24"
  private_cidr = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  #accessip                     = "0.0.0.0/0"
  availability_zone_ap_southeast_1 = ["ap-southeast-1a", "ap-southeast-1b"]
}

# sg_config = {
#   accessip = "0.0.0.0/0"

# }

sg = {
  web_sg = { #key
    name = "web_sg"
    ingress_rules = { #value 
      rule_1 = {

        description      = "Example Ingress 1"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      },
      rule_2 = {
        description      = "Example Ingress 2"
        from_port        = 443
        to_port          = 443
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
      rule_3 = {
        description      = "Example Ingress 3"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    }

  }
  db_sg = {
    name = "db_sg"
    ingress_rules = {
      rule_1 = {

        description      = "Example Ingress 1"
        from_port        = 3306
        to_port          = 3306
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    }
  }
}

tags = {
  Name = "Atlantis"
}

rds_cluster = {
  cluster_identifier      = "mysql-cluster-demo"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.12.0"
  availability_zones      = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
  database_name           = "mydb"
  master_username         = "tayyab"
  master_password         = "t123456789"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"

  db_instance = {

    identifier          = ["my-db"]
    instance_class      = "db.t3.small"
    publicly_accessible = false
    apply_immediately   = true
  }
}

launch_template = {
  name_prefix   = "wordpress_template"
  image_id      = "ami-0a95d2cc973f39afc"
  instance_type = "t2.micro"
  user_data     = "/home/tayab/Desktop/tfnew/asg/user_data.sh"
  resource_type = "instance"
}
my_asg = {
  name = "wordpress_asg"
  version = "$Latest"
  desired = "1"
  max     = "2"
  min     = "1"
}

alb = {
  name = "wordpress-alb"
  internal = "false"
  idle_timeout = "60" #it means that connections to the ALB will be closed by the ALB if they remain idle for longer than 60 seconds.
  ip_address_type = "ipv4"

  alb_listener = {
    port = "80"
    protocol = "HTTP"
}
}
alb_tg = {
    healthy_threshold = "3"
    unhealthy_threshold = "10"
    timeout = "5"
    interval = "10"
  }
