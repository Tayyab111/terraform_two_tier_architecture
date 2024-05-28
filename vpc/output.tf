output "vpc_id" {
  value = aws_vpc.tf_vpc.id 
}
output "subnet_ids" {
  description = "this is the list of private_subnet"
  value = aws_subnet.tf_private_subnet[*].id 
}
output "public_subnet_id" {
  value = aws_subnet.tf_public_subnet[*].id
}