terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "spacelift_flows" {
  source = "github.com/spacelift-io/terraform-aws-eks-spacelift-flows-selfhosted?ref=main"

  # Required variables
  app_domain        = var.app_domain
  organization_name = var.organization_name
  admin_email       = var.admin_email
  aws_region        = var.aws_region
  license_token = var.license_token

  # Optional variables
  k8s_namespace               = var.k8s_namespace
  enable_vpc                  = var.enable_vpc
  vpc_id                      = var.vpc_id
  private_subnet_ids          = var.private_subnet_ids
  public_subnet_ids           = var.public_subnet_ids
  database_security_group_ids = var.database_security_group_ids
}

# Required variables
variable "app_domain" {
  description = "The domain name for the Spacelift Flows instance"
  type        = string
}

variable "organization_name" {
  description = "Name of the organization"
  type        = string
}

variable "admin_email" {
  description = "Email address for the admin user"
  type        = string
}

variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
}

variable "license_token" {
  description = "The JWT token for using Spacelift flows. Only required for generating the kubernetes_secrets output."
  type        = string
  sensitive   = true
}

variable "k8s_namespace" {
  type = string
}

variable "enable_vpc" {
  description = "Whether to create a new VPC or use an existing one"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "ID of the existing VPC to use"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to use for the RDS instances and EKS cluster"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs to use for the EKS cluster"
  type        = list(string)
}

variable "database_security_group_ids" {
  description = "List of security group IDs to use for the RDS instances"
  type        = list(string)
}

output "config_secret_manifest" {
  description = "Outputs manifests that are needed to configure a secret for the Flows app."
  value       = module.spacelift_flows.config_secret_manifest
  sensitive   = true
}

output "ingress" {
  description = "Outputs manifests that are needed to configure aws ingress."
  value       = module.spacelift_flows.ingress_manifest
}

output "agent_pool_secret_manifest" {
  description = "Outputs manifests that are needed to configure a secret for the Flows Agent Pool."
  value       = module.spacelift_flows.agent_pool_secret_manifest
  sensitive   = true
}

output "shell" {
  value = module.spacelift_flows.shell
}