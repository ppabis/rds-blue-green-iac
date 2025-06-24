# Subnet Group for RDS
resource "aws_db_subnet_group" "rds" {
  name        = "postgresql-database-subnet-group"
  description = "Subnet group for RDS PostgreSQL database"
  subnet_ids  = var.subnet_ids
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
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  publicly_accessible    = false
  multi_az               = false # Single-AZ as requested

  # Authentication
  username                    = "root"
  manage_master_user_password = true

  # Backup and maintenance
  backup_retention_period    = 1
  deletion_protection        = false
  auto_minor_version_upgrade = false
}