output "db_instance_identifier" {
  description = "RDS Instance Identifier"
  value       = aws_db_instance.postgresql.id
}

output "db_endpoint" {
  description = "RDS Instance Endpoint"
  value       = aws_db_instance.postgresql.endpoint
}

output "db_port" {
  description = "RDS Instance Port"
  value       = aws_db_instance.postgresql.port
}

output "security_group_id" {
  description = "Security Group ID for RDS"
  value       = aws_security_group.rds.id
}

output "master_user_secret_arn" {
  description = "ARN of the master user secret in Secrets Manager"
  value       = aws_db_instance.postgresql.master_user_secret[0].secret_arn
  sensitive   = true
} 