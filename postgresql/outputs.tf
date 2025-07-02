output "db_endpoint" {
  description = "RDS Instance Endpoint"
  value       = aws_db_instance.postgresql.endpoint
}

output "db_arn" {
  value = aws_db_instance.postgresql.arn
}