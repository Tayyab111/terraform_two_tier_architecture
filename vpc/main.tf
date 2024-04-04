resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_config["vpc_cidr"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_config["vpc_name"]
  }
}
# IGW
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "tf_igw"
  }
}
resource "aws_eip" "nat_gateway_eip" {
  vpc = true
  depends_on = [ 
    aws_default_route_table.tf_private_rt
  ]
}
# NAT_GATEWAY +++ ====>
resource "aws_nat_gateway" "my_nat_gateway" {
   # count                   = length(var.vpc_config["private_cidr"]) != null ? 1 : 0      #  +++ ============>
    count = var.vpc_config["private_cidr"] != "" ? 1 : 0

    allocation_id = aws_eip.nat_gateway_eip.id 
    subnet_id     = aws_subnet.tf_public_subnet.id 
    depends_on = [ aws_eip.nat_gateway_eip ]

  tags = {
    Name = "gw NAT"
}
}
#ROUTE FOR NAT GATEWAY
resource "aws_route" "private_subnet_route" { 
  route_table_id            = aws_default_route_table.tf_private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.my_nat_gateway[0].id
}
# PUBLIC_RT
resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }

  tags = {
    Name = "tf_public_rt"
  }
}
# PRIVATE_RT
resource "aws_default_route_table" "tf_private_rt" {
  default_route_table_id  = aws_vpc.tf_vpc.default_route_table_id
  
  tags  = {
    Name = "tf_private_rt"
  }
}
# PUBLIC_SUBNET
resource "aws_subnet" "tf_public_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.vpc_config["public_cidr"]
  map_public_ip_on_launch = true
  availability_zone       = var.vpc_config["availability_zone_ap_south_1"]
  
  tags = {
    Name = "tf_public_subnet"
  }
}
# PRIVATE_SUBNET
resource "aws_subnet" "tf_private_subnet" {
    
    count = var.vpc_config["private_cidr"] != "" ? 1 : 0
    
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.vpc_config["private_cidr"]
    

  availability_zone       = var.vpc_config["availability_zone_ap_south_1"]

  tags = {
    Name = "tf_private_subnet"
  }
}
# PUBLIC_ASSOCCIATION
resource "aws_route_table_association" "tf_public_assoc" {
  subnet_id      = aws_subnet.tf_public_subnet.id
  route_table_id = aws_route_table.tf_public_rt.id
}
# PRIVATE_ASSOCCIATION
resource "aws_route_table_association" "tf_private_assoc" {
  subnet_id      = aws_subnet.tf_private_subnet[0].id #changes for if condition
  route_table_id = aws_default_route_table.tf_private_rt.id
}
# PUBLIC_SG
resource "aws_security_group" "tf_public_sg" {
  name        = "tf_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.tf_vpc.id

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
    cidr_blocks = [var.vpc_config["accessip"]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# PRIVATE_SG
resource "aws_security_group" "tf_private_sg" {
  name        = "tf_private_sg"
  description = "Used for access to the private instances"
  vpc_id      = aws_vpc.tf_vpc.id

  #SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.tf_public_sg.id]
  }

  #HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.tf_public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}