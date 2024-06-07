output "increase_ec2_arn" {
  value = aws_autoscaling_policy.increase_ec2.arn
}
output "decrease_ec2_arn" {
  value = aws_autoscaling_policy.decrease_ec2.arn
}

output "auto_scaling_name" {
  value = aws_autoscaling_group.my_asg.name
}