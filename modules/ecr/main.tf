resource "random_id" "ecr_suffix" {
  byte_length = 4
}

# ECR Repository for Spacelift Flows images
resource "aws_ecr_repository" "flows_images" {
  name                 = "spacelift-flows-${random_id.ecr_suffix.hex}"
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  force_delete = var.force_delete
}

# ECR Repository for Spacelift Agent images
resource "aws_ecr_repository" "agent_images" {
  name                 = "spacelift-agent-${random_id.ecr_suffix.hex}"
  image_tag_mutability = var.image_tag_mutability

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  force_delete = var.force_delete
}
