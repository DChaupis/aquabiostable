variable "key_pair_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
}