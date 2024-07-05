output "rds_id" {
  value = aws_rds_cluster.db_cluster.id 
}

output "cluster_endpoint" {
  description = "The endpoint for the RDS cluster"
  value = aws_rds_cluster.db_cluster.endpoint
}
output "db_name" {
  value = var.rds_cluster.database_name
  
}
output "user_name" {
  value = var.rds_cluster.master_username
}
# output "password" {
#   value = var.rds_cluster.master_password
  
# }
output "password" {
  value = aws_rds_cluster.db_cluster.master_password
}