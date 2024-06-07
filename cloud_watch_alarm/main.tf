# increase one ec2 f cpu is greater then 30. 
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name                = var.cpu_utilization.alarm_name
  comparison_operator       = var.cpu_utilization.comparison_operator
  evaluation_periods        = var.cpu_utilization.evaluation_periods
  metric_name               = var.cpu_utilization.metric_name
  namespace                 = var.cpu_utilization.namespace
  period                    = var.cpu_utilization.period
  statistic                 = var.cpu_utilization.statistic
  threshold                 = var.cpu_utilization.threshold
  alarm_description         = var.cpu_utilization.alarm_description
  insufficient_data_actions = var.cpu_utilization.insufficient_data_actions
  ok_actions = var.cpu_utilization.ok_actions
  alarm_actions = [
      "${aws_sns_topic.my_sns_topic.arn}",
      var.auto_scaling_policy_ec2_increment_arn
  ]
  dimensions = {
    AutoScalingGroupName = var.autoscaling_name_for_alarm
    }
  }

resource "aws_cloudwatch_metric_alarm" "low_cpu" {
  
  alarm_name = lookup(var.cpu_utilization.cpu_less_then_30, "alarm_name", var.cpu_utilization.alrm_name)
  comparison_operator = var.cpu_utilization.cpu_less_then_30.comparison_operator
  evaluation_periods = var.cpu_utilization.evaluation_periods
  metric_name = var.cpu_utilization.metric_name
  namespace = var.cpu_utilization.namespace
  period = var.cpu_utilization.period
  statistic = var.cpu_utilization.statistic
  threshold = var.cpu_utilization.cpu_less_then_30.threshold 
  alarm_description = var.cpu_utilization.cpu_less_then_30.alarm_description
  insufficient_data_actions = var.cpu_utilization.insufficient_data_actions
  ok_actions = var.cpu_utilization.ok_actions
  alarm_actions = [
    aws_sns_topic.my_sns_topic.arn,
    var.auto_scaling_policy_ec2_decrement_arn
  ]
  dimensions = {
    AutoScalingGroupName = var.autoscaling_name_for_alarm
    }
  }

resource "aws_sns_topic" "my_sns_topic" {
  name = var.sns_topic.name
}

resource "aws_sns_topic_subscription" "my_sns_topic_subscription" {
  topic_arn = aws_sns_topic.my_sns_topic.arn
  protocol  = var.sns_topic.topic_subscription.protocol
  endpoint  = var.sns_topic.topic_subscription.endpoint
}