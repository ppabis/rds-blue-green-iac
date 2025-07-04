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

output "instance_id" {
  value = module.vpc.instance_id
}

output "secret_arn" {
  value = module.vpc.root_password_arn
}

output "instance_public_dns" {
  value = module.vpc.instance_public_dns
}