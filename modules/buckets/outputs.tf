output "storage_bucket_name" {
  description = "Name of the main storage bucket"
  value       = aws_s3_bucket.flows_storage.id
}

output "storage_bucket_arn" {
  description = "ARN of the main storage bucket"
  value       = aws_s3_bucket.flows_storage.arn
}

output "access_policies" {
  description = "IAM policy statements for bucket access"
  value = {
    can_manage_storage_bucket = {
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
        aws_s3_bucket.flows_storage.arn,
        "${aws_s3_bucket.flows_storage.arn}/*"
      ]
    }
  }
}
