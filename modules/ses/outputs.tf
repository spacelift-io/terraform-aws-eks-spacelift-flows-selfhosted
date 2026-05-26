output "ses_identity_arn" {
  description = "ARN of the SES domain identity"
  value       = aws_ses_domain_identity.flows.arn
}

output "access_policies" {
  description = "IAM policy statements for SES access"
  value = {
    can_send_emails = {
      Effect = "Allow"
      Action = [
        "ses:SendEmail",
        "ses:SendRawEmail",
        "ses:SendBulkEmail"
      ]
      Resource = [aws_ses_domain_identity.flows.arn]
    }
  }
}

data "aws_region" "current" {}
