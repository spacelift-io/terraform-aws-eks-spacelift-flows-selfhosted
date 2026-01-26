locals {
  unique_suffix = lower(substr(random_uuid.suffix.id, 0, 5))
  cluster_name  = coalesce(var.eks_cluster_name, "spacelift-flows-${local.unique_suffix}")

  vpc_id                      = var.enable_vpc ? module.network[0].vpc_id : var.vpc_id
  private_subnet_ids          = var.enable_vpc ? module.network[0].private_subnet_ids : var.private_subnet_ids
  public_subnet_ids           = var.enable_vpc ? module.network[0].public_subnet_ids : var.public_subnet_ids
  database_security_group_ids = var.enable_vpc ? [module.network[0].database_security_group_ids] : var.database_security_group_ids
}

# Fetch availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Network Module
module "network" {
  count  = var.enable_vpc ? 1 : 0
  source = "./modules/network"

  cluster_name = local.cluster_name

  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

# KMS Module
module "kms" {
  source = "./modules/kms"

  aws_region              = var.aws_region
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

# Buckets Module
module "buckets" {
  source = "./modules/buckets"

  kms_key_arn       = module.kms.key_arn
  retain_on_destroy = var.s3_retain_on_destroy
}

# Database Module
module "database" {
  count  = var.enable_database ? 1 : 0
  source = "./modules/database"

  rds_cluster_configuration          = var.rds_cluster_configuration
  subnet_ids                         = local.private_subnet_ids
  kms_key_arn                        = module.kms.key_arn
  kms_key_id                         = module.kms.key_id
  database_security_group_ids        = local.database_security_group_ids
  database_delete_protection_enabled = var.rds_delete_protection_enabled
}

# SES Module
module "ses" {
  count  = var.enable_ses ? 1 : 0
  source = "./modules/ses"

  domain                      = var.app_domain
  kms_key_arn                 = module.kms.key_arn
  s3_bucket_retain_on_destroy = var.s3_retain_on_destroy
}

# ECR Module
module "ecr" {
  count  = var.enable_ecr ? 1 : 0
  source = "./modules/ecr"

  kms_key_arn          = module.kms.key_arn
  image_tag_mutability = var.ecr_image_tag_mutability
  scan_on_push         = var.ecr_scan_on_push
  force_delete         = var.ecr_force_delete
}

# Request ACM certificate (only if cert_arn is not provided)
resource "aws_acm_certificate" "flows" {
  count = var.cert_arn == null ? 1 : 0

  domain_name = var.app_domain

  subject_alternative_names = concat([
    "*.endpoints.${var.app_domain}",
    "oauth.${var.app_domain}",
    "mcp.${var.app_domain}",
  ], var.expose_gateway ? ["gateway.${var.app_domain}"] : [])
  validation_method = "DNS"
}


# Random resources for default agent pool
resource "random_uuid" "default_agent_pool_id" {}

resource "random_password" "default_agent_pool_token" {
  length  = 64
  special = false
  upper   = false
}


data "aws_caller_identity" "current" {}
