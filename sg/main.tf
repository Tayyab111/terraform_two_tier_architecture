resource "aws_security_group" "public_sg" {
  
  name = var.sg_config.name 
  tags = merge(var.tags , {Name = var.sg_config.name}) # dele da errror va: │ Inappropriate value for attribute "name": string required.

  vpc_id = var.vpc_id
  dynamic "ingress" {
    for_each = var.sg_config.ingress_rules
      
     content {
      
      description      = ingress.value.description
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = ingress.value.cidr_blocks
      ipv6_cidr_blocks = ingress.value.ipv6_cidr_blocks
    }
}
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
