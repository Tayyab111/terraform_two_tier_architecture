resource "aws_launch_template" "my_launch_template" {
name_prefix   = "${var.tags.Name}-${var.launch_template.name_prefix}"
  image_id      = var.launch_template.image_id # To note: AMI is specific for each region
  instance_type = var.launch_template.instance_type
  #user_data     = filebase64("user_data.sh")
  #user_data = filebase64(var.launch_template.user_data)
  user_data = base64encode(data.template_file.my_template.rendered)
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = var.public_subnet_id[0] #var.public_subnet_id is tuple with 1 element: Inappropriate value for attribute "subnet_id": string required.
    security_groups             = [var.sg_id[0]]

  }
  tag_specifications {
    resource_type = var.launch_template.resource_type
    tags = merge(var.tags, {Name = "wordpress-ec2"})
  }
  tags = merge(var.tags, {Name = "wordpress_template_tag"})
}

data "template_file" "my_template" {
  template = file("${path.module}/user_data.sh")
  vars = {
    dbname = var.db_name
    username = var.master_username
    password = var.master_password
    db_endpoint = var.cluster_endpoint
  }
}