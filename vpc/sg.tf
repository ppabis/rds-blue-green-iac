# Security Group for experiment instances (complete egress, no ingress)
resource "aws_security_group" "experiment_instance" {
  name_prefix = "experiment-instance-sg"
  description = "Security group for experiment instances with complete egress access"
  vpc_id      = module.vpc.vpc_id
  tags        = { Name = "experiment-instance-sg" }

  dynamic "ingress" {
    for_each = var.my_ip != "" ? [var.my_ip] : []
    content {
      from_port   = 8080
      to_port     = 8081
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Security Group for PostgreSQL (allows ingress on PostgreSQL port from experiment-instance-sg)
resource "aws_security_group" "postgresql" {
  name_prefix = "postgresql-sg"
  description = "Security group for PostgreSQL database"
  vpc_id      = module.vpc.vpc_id
  tags        = { Name = "postgresql-sg" }

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.experiment_instance.id]
    description     = "PostgreSQL access from experiment instances"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# Security Group for MySQL (allows ingress on MySQL port from experiment-instance-sg)
resource "aws_security_group" "mysql" {
  name_prefix = "mysql-sg"
  description = "Security group for MySQL database"
  vpc_id      = module.vpc.vpc_id
  tags        = { Name = "mysql-sg" }

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.experiment_instance.id]
    description     = "MySQL access from experiment instances"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}