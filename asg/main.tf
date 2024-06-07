resource "aws_autoscaling_group" "my_asg" {
  # no of instances
  name = var.my_asg.name
  desired_capacity = var.my_asg.desired
  max_size         = var.my_asg.max 
  min_size         = var.my_asg.min 

  # Connect to the target group
  #target_group_arns = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier = [ var.private_subnet_id[0] ]

  launch_template {
    id = var.lanuch_template_output
    version = var.my_asg.version
  }
  
}
resource "aws_autoscaling_attachment" "name" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  lb_target_group_arn = var.alb_target_arn
}

resource "aws_autoscaling_policy" "increase_ec2" {
  name                   = var.asg_scaling_policy.increase_one_ec2.name
  adjustment_type        = var.asg_scaling_policy.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  policy_type            = var.asg_scaling_policy.policy_type

  step_adjustment {
    scaling_adjustment          = 1
    metric_interval_lower_bound = 30 #This applies when the metric is greater than or equal to 30%.
    metric_interval_upper_bound = 80 // This applies when the metric is less than or equal to 80%.

  }
  step_adjustment {
    scaling_adjustment = 2
    metric_interval_lower_bound = 80
  }
}


resource "aws_autoscaling_policy" "decrease_ec2" {
  name                   = var.asg_scaling_policy.increase_one_ec2.name
  adjustment_type        = var.asg_scaling_policy.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  policy_type            = var.asg_scaling_policy.policy_type

  step_adjustment {
    scaling_adjustment = -2
    metric_interval_lower_bound = 0
    
}
}
