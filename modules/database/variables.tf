variable "subnet_ids" {
  description = "List of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "kms_key_arn" {
  description = "KMS key ARN for database encryption"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for database encryption"
  type        = string
}

variable "database_security_group_ids" {
  description = "Security group ID to allow access to the database"
  type        = list(string)
}

variable "rds_cluster_configuration" {
  type = object({
    instance_identifier = string
    instance_class      = string
  })
  description = "Instance configuration for the RDS instances."
}

variable "database_delete_protection_enabled" {
  type = bool
}