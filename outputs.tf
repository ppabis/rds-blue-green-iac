output "postgresql_db_arn" {
  value = module.postgresql.db_arn
}

output "mysql_db_arn" {
  value = aws_cloudformation_stack.mysql-database.outputs["DBInstanceArn"]
}

output "postgresql_db_endpoint" {
  value = module.postgresql.db_endpoint
}

output "mysql_db_endpoint" {
  value = aws_cloudformation_stack.mysql-database.outputs["DBEndpoint"]
}