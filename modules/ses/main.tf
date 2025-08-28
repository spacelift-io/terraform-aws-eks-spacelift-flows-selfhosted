resource "random_id" "ses_suffix" {
  byte_length = 4
}

# SES domain identity
resource "aws_ses_domain_identity" "flows" {
  domain = var.domain
}

# DKIM configuration
resource "aws_ses_domain_dkim" "flows" {
  domain = aws_ses_domain_identity.flows.domain
}

# IAM user for sending emails
resource "aws_iam_user" "ses_user" {
  name = "flows-ses-user"
}

resource "aws_iam_user_policy" "ses_user" {
  name = "flows-ses-send-email"
  user = aws_iam_user.ses_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "ses:FromAddress" = "noreply@${var.domain}"
          }
        }
      }
    ]
  })
}

resource "aws_iam_access_key" "ses_user" {
  user = aws_iam_user.ses_user.name
}

# Email storage bucket (optional)
resource "aws_s3_bucket" "emails" {
  bucket = "flows-emails-${random_id.ses_suffix.hex}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "emails" {
  bucket = aws_s3_bucket.emails.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "emails" {
  bucket = aws_s3_bucket.emails.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "emails" {
  bucket = aws_s3_bucket.emails.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowSESPuts"
        Effect = "Allow"
        Principal = {
          Service = "ses.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.emails.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}

# SES receipt rule set
resource "aws_ses_receipt_rule_set" "flows" {
  rule_set_name = "flows-rules"
}

resource "aws_ses_active_receipt_rule_set" "flows" {
  rule_set_name = aws_ses_receipt_rule_set.flows.rule_set_name
}

resource "aws_ses_receipt_rule" "store_emails" {
  name          = "store-emails"
  rule_set_name = aws_ses_receipt_rule_set.flows.rule_set_name
  enabled       = true
  scan_enabled  = true

  s3_action {
    bucket_name       = aws_s3_bucket.emails.id
    object_key_prefix = "emails/"
    position          = 1
  }

  depends_on = [aws_s3_bucket_policy.emails]
}
