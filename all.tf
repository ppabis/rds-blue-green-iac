# This combines all the modules together
variable "my_ip" {
  type        = string
  description = "Your IP address"
  default     = "127.1.1.1/32"
}

module "vpc" {
  source = "./vpc"
  my_ip  = var.my_ip
  secret_name = "rds-root-password-20250702"
}

module "postgresql" {
  source            = "./postgresql"
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.vpc.postgresql_sg_id
  secret_name       = module.vpc.secret_name
}

resource "aws_cloudformation_stack" "mysql-database" {
  name          = "mysql-database"
  template_body = file("mysql/mysql.yaml")
  parameters = {
    SecurityGroupId = module.vpc.mysql_sg_id
    SubnetIds       = join(",", module.vpc.private_subnet_ids)
    SecretName      = module.vpc.secret_name
  }
}