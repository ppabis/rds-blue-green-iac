# VPC Outputs
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "postgresql_sg_id" {
  description = "The ID of the PostgreSQL security group"
  value       = aws_security_group.postgresql.id
}

output "mysql_sg_id" {
  description = "The ID of the MySQL security group"
  value       = aws_security_group.mysql.id
}

# EC2 Instance Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.experiment_instance.id
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.experiment_instance.public_dns
}