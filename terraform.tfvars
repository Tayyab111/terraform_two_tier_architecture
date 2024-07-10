region = "ap-southeast-1"


vpc_config = {

  vpc_name    = "my_vpc"
  vpc_cidr    = "10.0.0.0/16"
  public_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #private_cidr =  "10.0.11.0/24"
  private_cidr = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  #accessip                     = "0.0.0.0/0"
  availability_zone_ap_southeast_1 = ["us-east-1a", "us-east-1b"]
}


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
  availability_zones      = ["us-east-1a", "us-east-1b", "us-east-1c"]
  database_name           = "mydb"
  master_username         = "tayyab"
  #master_password         = "t123456789"
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
  image_id      = "ami-0195204d5dce06d99" #"ami-0a95d2cc973f39afc"
  instance_type = "t2.small"
  user_data     = "/home/tayab/Desktop/tfnew/asg/user_data.sh"
  resource_type = "instance"
}
my_asg = {
  name    = "wordpress_asg"
  version = "$Latest"
  desired = 1
  max     = 4
  min     = 1
}
asg_scaling_policy_scale_out = {
  name = "increase-one-ec2"
  adjustment_type    = "ChangeInCapacity"
  #cooldown           = 200 # cooldown is only supported for policy type SimpleScaling
  policy_type        = "StepScaling"
  increase_one_ec2 = {
    scaling_adjustment = 1
    metric_interval_lower_bound = 30
    metric_interval_upper_bound = 80
  }
  increase_two_ec2 = {
    name               = "increase-two-ec2"
    scaling_adjustment = 2
    metric_interval_lower_bound = 80
  }
}
asg_scaling_policy_scale_in = {
  name = "increase-one-ec2"
  adjustment_type    = "ChangeInCapacity"
  policy_type = "StepScaling"
    decrease_two_ec2 = {
    scaling_adjustment = -2
    metric_interval_lower_bound = 0
  }
}


alb = {
  name            = "wordpress-alb"
  internal        = "false"
  idle_timeout    = 400 #it means that connections to the ALB will be closed by the ALB if they remain idle for longer than 60 seconds.
  ip_address_type = "ipv4"

  alb_listener = {
    port     = 80
    protocol = "HTTP"
  }
}
alb_tg = {
  healthy_threshold   = 3
  unhealthy_threshold = 10
  timeout             = 5
  interval            = 10
  matcher             = "200-303"
}

cpu_utilization = { # for alarm
  alarm_name                = "increase_ec2"
  alrm_name                 = "low"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 2
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = 120
  statistic                 = "Average"
  threshold                 = "30"
  alarm_description         = "This metric monitors ec2 cpu utilization, if it goes above 40% for 2 periods it will trigger an alarm"
  insufficient_data_actions = []
  ok_actions                = []

  cpu_less_then_30 = {
    alarm_name          = "descrase_ec2"
    comparison_operator = "LessThanOrEqualToThreshold"
    threshold           = "30"
    alarm_description   = "This metric monitors ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
  }
}


sns_topic = {
  name = "cpu_alarm_topic_sns"
  topic_subscription = {
    protocol = "email"
    endpoint = "tayyabafridi843@gmail.com"
  }
}