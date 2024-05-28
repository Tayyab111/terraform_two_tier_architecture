resource "aws_autoscaling_group" "my_asg" {
  # no of instances
  name = var.my_asg.name
  desired_capacity = var.my_asg.desired
  max_size         = var.my_asg.max 
  min_size         = var.my_asg.min 

  # Connect to the target group
  #target_group_arns = [aws_lb_target_group.my_tg.arn]

  vpc_zone_identifier = [ var.public_subnet_id[0] ]

  launch_template {
    id = var.lanuch_template_output
    version = var.my_asg.version
  }
  
}
resource "aws_autoscaling_attachment" "name" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  lb_target_group_arn = var.alb_target_arn
}