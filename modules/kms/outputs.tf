output "key_id" {
  description = "The globally unique identifier for the key"
  value       = aws_kms_key.flows.key_id
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key"
  value       = aws_kms_key.flows.arn
}

output "access_policies" {
  description = "IAM policy statements for KMS access"
  value = {
    can_use_kms_key = {
      Effect = "Allow"
      Action = [
        "kms:Decrypt",
        "kms:DescribeKey"
      ]
      Resource = [aws_kms_key.flows.arn]
    }
    can_encrypt_with_kms_key = {
      Effect = "Allow"
      Action = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      Resource = [aws_kms_key.flows.arn]
    }
  }
}
