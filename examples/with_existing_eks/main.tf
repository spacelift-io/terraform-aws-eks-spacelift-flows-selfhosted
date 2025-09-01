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
  license_token     = var.license_token

  # Optional variables
  k8s_namespace      = var.k8s_namespace
  enable_eks_cluster = var.enable_eks_cluster
  eks_cluster_name   = var.eks_cluster_name
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

variable "enable_eks_cluster" {
  description = "Whether to create a new EKS cluster or use an existing one"
  type        = bool
  default     = false
}

variable "eks_cluster_name" {
  description = "Name of the existing EKS cluster to use"
  type        = string
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