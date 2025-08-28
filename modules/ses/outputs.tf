output "smtp_username" {
  description = "SMTP username (AWS access key ID)"
  value       = aws_iam_access_key.ses_user.id
  sensitive   = true
}

output "smtp_password" {
  description = "SMTP password (derived from secret access key)"
  value       = aws_iam_access_key.ses_user.ses_smtp_password_v4
  sensitive   = true
}

output "smtp_server" {
  description = "SMTP server endpoint"
  value       = "email-smtp.${data.aws_region.current.name}.amazonaws.com"
}

output "noreply_email" {
  description = "The noreply email address"
  value       = "noreply@${var.domain}"
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
      Resource = ["*"]
    }
  }
}

data "aws_region" "current" {}
