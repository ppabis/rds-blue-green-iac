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