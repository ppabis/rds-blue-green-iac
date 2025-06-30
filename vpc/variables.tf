variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.199.199.0/24"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "my_ip" {
  description = "Subnet for you to access the monitoring app (optional, leave \"\" for no access) otherwise give CIDR like 1.2.3.4/32"
  type        = string
  default     = ""
}