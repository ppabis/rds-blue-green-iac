# Variables
variable "vpc_id" {
  description = "VPC ID where the RDS instance will be deployed"
  type        = string
}

# Data sources
data "aws_vpc" "selected" {
  id = var.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }

  filter {
    name   = "tag:Type"
    values = ["Private"]
  }
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name_prefix = "postgresql-database-sg-"
  description = "Security group for RDS PostgreSQL database"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
    description = "PostgreSQL access from VPC CIDR"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "postgresql-database-sg"
  }
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "rds" {
  name        = "postgresql-database-subnet-group"
  description = "Subnet group for RDS PostgreSQL database"
  subnet_ids  = data.aws_subnets.private.ids
}

# RDS Instance
resource "aws_db_instance" "postgresql" {
  identifier = "postgresql-database"

  # Database configuration
  db_name        = "postgresql_database"
  engine         = "postgres"
  engine_version = "13.12" # PostgreSQL 13.x as requested

  # Instance configuration
  instance_class    = "db.t4g.medium"
  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  # Network configuration
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  publicly_accessible    = false
  multi_az               = false # Single-AZ as requested

  # Authentication
  manage_master_user_password = true

  # Backup and maintenance
  backup_retention_period    = 1
  deletion_protection        = false
  auto_minor_version_upgrade = false
}

# Outputs
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