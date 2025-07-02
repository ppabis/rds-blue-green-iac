variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID"
}

variable "secret_name" {
  type        = string
  description = "Secret name"
}