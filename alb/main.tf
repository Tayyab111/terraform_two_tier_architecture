resource "aws_alb" "my_alb" {
  name            = "${var.tags.Name}-${var.alb.name}"
  subnets         = var.public_subnet_id
  security_groups = var.sg_id
  internal        = var.alb.internal
  idle_timeout    = var.alb.idle_timeout
  ip_address_type = var.alb.ip_address_type
  tags = merge(var.tags , {Name = "wordprss_alb_tag"}) 
}
resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.my_alb.arn
  port              =   var.alb.alb_listener.port
  protocol          = var.alb.alb_listener.protocol
  
  default_action {    
    target_group_arn = aws_alb_target_group.alb_target_group.arn 
    type             = "forward"
  }
}
resource "aws_alb_target_group" "alb_target_group" {

  name = "${var.tags.Name}-wordpress-tg"
  port     = var.alb.alb_listener.port
  protocol = var.alb.alb_listener.protocol
  vpc_id  = var.vpc_id
  tags = merge(var.tags, {Name = "wordpress_tg_tag"})

  health_check {
    healthy_threshold   = var.alb_tg.healthy_threshold
    unhealthy_threshold = var.alb_tg.unhealthy_threshold
    timeout             = var.alb_tg.timeout
    interval            = var.alb_tg.interval
    matcher             = var.alb_tg.matcher # it will return health status between(200-303)
  }
}
