# Generate a random password
resource "random_password" "root_password" {
  length           = 32
  special          = true
  override_special = ".,-_"
}

# Create the secret in AWS Secrets Manager
resource "aws_secretsmanager_secret" "root_password" {
  name        = var.secret_name
  description = "Root password for RDS MySQL database"
}

# Store the password in the secret
resource "aws_secretsmanager_secret_version" "root_password" {
  secret_id = aws_secretsmanager_secret.root_password.id
  secret_string = jsonencode({
    username = "root"
    password = random_password.root_password.result
  })
}