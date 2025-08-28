variable "domain" {
  description = "The domain to configure for SES"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for email bucket encryption"
  type        = string
}

variable "s3_bucket_retain_on_destroy" {
  type        = bool
  description = "Whether to retain the bucket and its contents when destroyed. The objects can be recovered."
}