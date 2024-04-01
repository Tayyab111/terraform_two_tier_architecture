resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_config["vpc_cidr"]
  # den_hostname reolce ip into www.somting.com 
  enable_dns_hostnames = true
  # dns_support resolve  www.someting.com into ip 
  enable_dns_support   = true


  tags = {
    Name = var.vpc_config["vpc_name"]
  }
}
# INTERNET GATEWAY
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}
#        PUBLIC ROUTE TABLE
resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }

  tags = {
    Name = "tf_public"
  }
}
# PRIVATE ROUTE TABLE (jo by-default route_table para tha us private bana ye)
resource "aws_default_route_table" "tf_private_rt" {
  default_route_table_id  = aws_vpc.tf_vpc.default_route_table_id

  tags = {
    Name = "tf_private"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  #count                   = 2
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.vpc_config["public_cidrs"] #[count.index]
  map_public_ip_on_launch = true
  #availability_zone       = lookup(var.availability_zones_ap_south_1, count.index)
  availability_zone =  var.vpc_config["availability_zones_ap_south_1"]
  tags = {
    Name = "tf public" #${count.index +1}"
  }
}

resource "aws_subnet" "tf_private_subnet" {
  #count                   = 4
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.vpc_config["private_cidrs"] #[count.index]
  #availability_zone       = lookup(var.availability_zones_ap_south_1, count.index%2)
  availability_zone = var.vpc_config["availability_zones_ap_south_1"]


  tags = {
    Name = "tf_private" #${count.index +1}"
  }
}

resource "aws_route_table_association" "tf_public_assoc" {
  #count          = aws_subnet.tf_public_subnet.count
  subnet_id      = aws_subnet.tf_public_subnet.id #.*.id[count.index]
  route_table_id = aws_route_table.tf_public_rt.id
}
resource "aws_route_table_association" "tf_private_assoc" {
  #count          = aws_subnet.tf_private_subnet.count
  subnet_id      = aws_subnet.tf_private_subnet.id #*.id[count.index]
  route_table_id = aws_default_route_table.tf_private_rt.id
}

# sg
resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.tf_vpc.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_config["accessip"]]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.vpc_config["accessip"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "tf_private_sg" {
  name        = "tf_private_sg"
  description = "Used for access to the private instances"
  vpc_id      = "${aws_vpc.tf_vpc.id}"

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = ["${aws_security_group.tf_public_sg.id}"]
  }

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = ["${aws_security_group.tf_public_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}