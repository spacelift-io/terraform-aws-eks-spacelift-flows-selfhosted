variable "domain" {
  description = "The domain to configure for SES"
  type        = string
}

variable "kms_key_arn" {
  description = "ARN of the KMS key for email bucket encryption"
  type        = string
}
