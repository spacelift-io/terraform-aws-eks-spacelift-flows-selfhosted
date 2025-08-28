data "aws_caller_identity" "current" {}

resource "aws_kms_key" "flows" {
  description             = "Flows encryption key"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "flows-key-policy"
    Statement = concat(
      [
        {
          Sid    = "Enable IAM User Permissions"
          Effect = "Allow"
          Principal = {
            AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          }
          Action   = "kms:*"
          Resource = "*"
        },
        {
          Sid    = "Allow services to use the key"
          Effect = "Allow"
          Principal = {
            Service = [
              "s3.amazonaws.com",
              "rds.amazonaws.com",
              "ses.amazonaws.com",
              "secretsmanager.amazonaws.com",
              "logs.${var.aws_region}.amazonaws.com"
            ]
          }
          Action = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*",
            "kms:CreateGrant",
            "kms:DescribeKey"
          ]
          Resource = "*"
        }
      ],
    )
  })
}

resource "aws_kms_alias" "flows" {
  name          = "alias/flows"
  target_key_id = aws_kms_key.flows.key_id
}
