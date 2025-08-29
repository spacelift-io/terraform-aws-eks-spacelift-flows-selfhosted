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
  k8s_namespace     = var.k8s_namespace
  smtp_host         = var.smtp_host
  smtp_port         = var.smtp_port
  smtp_username     = var.smtp_username
  smtp_password     = var.smtp_password
  smtp_from_address = var.smtp_from_address
  smtp_from_name    = var.smtp_from_name
  smtp_encryption   = var.smtp_encryption
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

# SMTP Configuration variables
variable "smtp_host" {
  description = "SMTP server host"
  type        = string
}

variable "smtp_port" {
  description = "SMTP server port"
  type        = number
  default     = 587
}

variable "smtp_username" {
  description = "SMTP server username"
  type        = string
}

variable "smtp_password" {
  description = "SMTP server password"
  type        = string
  sensitive   = true
}

variable "smtp_from_address" {
  description = "SMTP from address"
  type        = string
}

variable "smtp_from_name" {
  description = "SMTP from name"
  type        = string
  default     = "Spacelift Flows"
}

variable "smtp_encryption" {
  description = "SMTP encryption method (tls, starttls, or none)"
  type        = string
  default     = "starttls"
  validation {
    condition     = contains(["tls", "starttls", "none"], var.smtp_encryption)
    error_message = "SMTP encryption must be one of: tls, starttls, none."
  }
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