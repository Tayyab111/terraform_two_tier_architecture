resource "aws_vpc" "tf_vpc" {
  cidr_block           = var.vpc_config["vpc_cidr"]
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(var.tags , {Name =  var.vpc_config.vpc_name}) 
  
}

data "aws_availability_zones" "available"{

}
# IGW 
resource "aws_internet_gateway" "tf_internet_gateway" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = merge(var.tags , {Name = "tf_igw"})
  
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
    count = length(var.vpc_config["private_cidr"]) > 0 ? 1 : 0

    allocation_id = aws_eip.nat_gateway_eip.id
    connectivity_type = "public"
    subnet_id     = aws_subnet.tf_public_subnet[0].id 
    
    #depends_on = [ aws_route.private_subnet_route ]

  tags = merge(var.tags , { Name = "gw NAT"})

}
# ROUTE FOR NAT GATEWAY
resource "aws_route" "private_subnet_route" { 
  route_table_id            = aws_default_route_table.tf_private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.my_nat_gateway[0].id
  depends_on = [ aws_default_route_table.tf_private_rt ]
}
# PUBLIC_ROUTE_TABLE
resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_internet_gateway.id
  }

  tags = merge(var.tags , {Name = "tf_public_rt"}) 
  }

# PRIVATE_ROUTE_TABLE
resource "aws_default_route_table" "tf_private_rt" {
  default_route_table_id  = aws_vpc.tf_vpc.default_route_table_id
  depends_on = [ aws_subnet.tf_private_subnet ]
  tags  = merge(var.tags , { Name = "tf_private_rt"})
  
}
# PUBLIC_SUBNET

resource "aws_subnet" "tf_public_subnet" {
    count =   length(var.vpc_config.public_cidr)

  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.vpc_config.public_cidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = element(data.aws_availability_zones.available.names , count.index)
  
  tags = merge(var.tags , {Name = "tf_public_subnet"}) 
  
}
# PRIVATE_SUBNET
resource "aws_subnet" "tf_private_subnet" {
    
  count =   length(var.vpc_config.private_cidr)  
  vpc_id                  = aws_vpc.tf_vpc.id
  map_public_ip_on_launch = false 
  cidr_block              = var.vpc_config.private_cidr[count.index]
  availability_zone = element(data.aws_availability_zones.available.names , count.index)
  #availability_zone       = var.vpc_config["availability_zone_ap_southeast_1"]
  tags = merge(var.tags , {Name = "tf_private_subnet"}) 
  
}
# PUBLIC_ASSOCCIATION
resource "aws_route_table_association" "tf_public_assoc" {
  subnet_id      = aws_subnet.tf_public_subnet[0].id
  route_table_id = aws_route_table.tf_public_rt.id
}
# PRIVATE_ASSOCCIATION
resource "aws_route_table_association" "tf_private_assoc" {
  subnet_id      = aws_subnet.tf_private_subnet[0].id 
  route_table_id = aws_default_route_table.tf_private_rt.id
}
