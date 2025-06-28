data "aws_secretsmanager_secret" "root_password" {
  name = "rds-root-password"
}

data "aws_secretsmanager_secret_version" "root_password" {
  secret_id = data.aws_secretsmanager_secret.root_password.id
}

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
  engine_version = "13.21" # PostgreSQL 13.x as requested

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
  password                    = jsondecode(data.aws_secretsmanager_secret_version.root_password.secret_string).password

  # Backup and maintenance
  backup_retention_period    = 1
  deletion_protection        = false
  auto_minor_version_upgrade = false
  skip_final_snapshot        = true
}