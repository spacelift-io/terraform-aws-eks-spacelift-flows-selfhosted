# IRSA: IAM role for the spacelift-flows Kubernetes service account
resource "aws_iam_role" "flows_irsa" {
  count = var.enable_eks_cluster ? 1 : 0

  name = "spacelift-flows-${local.unique_suffix}-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = module.eks[0].oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks[0].oidc_provider}:sub" = "system:serviceaccount:${var.k8s_namespace}:${var.service_account_name}"
            "${module.eks[0].oidc_provider}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "flows_s3_access" {
  count = var.enable_eks_cluster ? 1 : 0

  name = "spacelift-flows-${local.unique_suffix}-s3-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:ListBucketVersions",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]
        Resource = [
          module.buckets.storage_bucket_arn,
          "${module.buckets.storage_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "kms:GenerateDataKey",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = module.kms.key_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "flows_s3_access" {
  count = var.enable_eks_cluster ? 1 : 0

  role       = aws_iam_role.flows_irsa[0].name
  policy_arn = aws_iam_policy.flows_s3_access[0].arn
}

resource "aws_iam_policy" "flows_ses_access" {
  count = var.enable_eks_cluster && var.enable_ses ? 1 : 0

  name = "spacelift-flows-${local.unique_suffix}-ses-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail",
          "ses:SendBulkEmail"
        ]
        Resource = ["arn:aws:ses:${var.aws_region}:${data.aws_caller_identity.current.account_id}:identity/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "flows_ses_access" {
  count = var.enable_eks_cluster && var.enable_ses ? 1 : 0

  role       = aws_iam_role.flows_irsa[0].name
  policy_arn = aws_iam_policy.flows_ses_access[0].arn
}
