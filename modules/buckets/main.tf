resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Main storage bucket
resource "aws_s3_bucket" "flows_storage" {
  bucket = "flows-${random_id.bucket_suffix.hex}"

  force_destroy = !var.retain_on_destroy
}

resource "aws_s3_bucket_versioning" "flows_storage" {
  bucket = aws_s3_bucket.flows_storage.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "flows_storage" {
  bucket = aws_s3_bucket.flows_storage.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "flows_storage" {
  bucket = aws_s3_bucket.flows_storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

