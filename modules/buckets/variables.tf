variable "kms_key_arn" {
  description = "ARN of the KMS key for bucket encryption"
  type        = string
}


variable "retain_on_destroy" {
  type        = bool
  description = "Whether to retain the bucket and its contents when destroyed. The objects can be recovered."
}