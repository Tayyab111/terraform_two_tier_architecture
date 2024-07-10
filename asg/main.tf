resource "aws_autoscaling_group" "my_asg" {
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
  name                   = var.asg_scaling_policy_scale_out.name
  adjustment_type        = var.asg_scaling_policy_scale_out.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  policy_type            = var.asg_scaling_policy_scale_out.policy_type
  
  
  step_adjustment {
    scaling_adjustment          = var.asg_scaling_policy_scale_out.increase_one_ec2.scaling_adjustment
    metric_interval_lower_bound = var.asg_scaling_policy_scale_out.increase_one_ec2.metric_interval_lower_bound #This applies when the metric is greater than or equal to 30%.
    metric_interval_upper_bound = var.asg_scaling_policy_scale_out.increase_one_ec2.metric_interval_upper_bound // This applies when the metric is less than or equal to 80%.

  }
  step_adjustment {
    scaling_adjustment = var.asg_scaling_policy_scale_out.increase_two_ec2.scaling_adjustment
    metric_interval_lower_bound = var.asg_scaling_policy_scale_out.increase_two_ec2.metric_interval_lower_bound
  }
}


resource "aws_autoscaling_policy" "decrease_ec2" {
  name                   = "decrease_ec2"#var.asg_scaling_policy_scale_in.name
  adjustment_type        = "ChangeInCapacity"#var.asg_scaling_policy_scale_in.adjustment_type
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
  policy_type            = "StepScaling"#var.asg_scaling_policy_scale_in.policy_type
  

  step_adjustment {
    scaling_adjustment = -2 #var.asg_scaling_policy_scale_in.decrease_two_ec2.scaling_adjustment
    metric_interval_lower_bound = 1 #var.asg_scaling_policy_scale_in.decrease_two_ec2.metric_interval_lower_bound
    
}
}
