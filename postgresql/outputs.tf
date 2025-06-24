output "db_endpoint" {
  description = "RDS Instance Endpoint"
  value       = aws_db_instance.postgresql.endpoint
}

output "master_user_secret_arn" {
  description = "ARN of the master user secret in Secrets Manager"
  value       = aws_db_instance.postgresql.master_user_secret[0].secret_arn
  sensitive   = true
} 