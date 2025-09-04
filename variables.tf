variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}


variable "license_token" {
  description = "The JWT token for using Spacelift flows. Only required for generating the kubernetes_secrets output."
  type        = string
  sensitive   = true
}

variable "app_domain" {
  type = string
}

variable "k8s_namespace" {
  default = "default"
}

variable "s3_retain_on_destroy" {
  type        = bool
  description = "Whether to retain the S3 buckets' contents when destroyed. If true, and the S3 bucket isn't empty, the deletion will fail."
  default     = true
}

variable "rds_delete_protection_enabled" {
  type        = bool
  description = "Whether to enable the rds delete protection."
  default     = true
}

variable "rds_cluster_configuration" {
  type = object({
    instance_identifier = string
    instance_class      = string
  })
  description = "Instance configuration for the RDS instances."
  default = {
    instance_identifier = "flows-instance-1"
    instance_class      = "db.t4g.medium"
  }
}


# Configuration variables for the generated config secret
variable "opentelemetry_collector_endpoint" {
  description = "OpenTelemetry collector endpoint"
  type        = string
  default     = ""
}

variable "opentelemetry_environment" {
  description = "OpenTelemetry environment name"
  type        = string
}

variable "anthropic_api_key" {
  description = "Anthropic API key for AI features"
  type        = string
  default     = ""
  sensitive   = true
}

variable "email_dev_enabled" {
  description = "Enable development email mode. The magic link for login will be printed to the server logs."
  type        = bool
  default     = false
}

variable "organization_name" {
  description = "Organization name for self-hosted deployment"
  type        = string
}

variable "admin_email" {
  description = "Admin email for self-hosted deployment"
  type        = string
}

variable "server_port" {
  description = "Server port for HTTP listener"
  type        = number
  default     = 8080
}

# SMTP Configuration variables
variable "smtp_host" {
  description = "SMTP server host"
  type        = string
  default     = ""
}

variable "smtp_port" {
  description = "SMTP server port"
  type        = number
  default     = 587
}

variable "smtp_username" {
  description = "SMTP server username"
  type        = string
  default     = ""
}

variable "smtp_password" {
  description = "SMTP server password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "smtp_from_address" {
  description = "SMTP from address"
  type        = string
  default     = ""
}

variable "database_connection_url" {
  type        = string
  sensitive   = true
  default     = ""
  description = "Provide this value, if enable_database is false and you want to configure configuration flows secret from the module."
}

variable "enable_database" {
  type        = bool
  default     = true
  description = "Switch this to false if you don't want to deploy a new RDS instance for Spacelift flows."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID to use if enable_vpc is false."
  default     = null
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs to use for the RDS instances and EKS cluster. If enable_vpc is false, this must be provided."
  default     = []
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs to use for the EKS cluster. If enable_vpc is false, this must be provided."
  default     = []
}

variable "database_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to use for the RDS instances. If enable_eks_cluster is false, this must be provided."
  default     = []
}


variable "enable_eks_cluster" {
  description = "Switch this to false to disable deployment of an EKS cluster."
  default     = true
  type        = bool
}

variable "enable_vpc" {
  default     = true
  description = "Switch this to false to disable VPC creation."
  type        = bool
}

variable "eks_cluster_name" {
  description = "A custom name to use for the EKS cluster. By default one will be generated for you."
  default     = null
}

variable "eks_cluster_version" {
  type        = string
  description = "The Kubernetes version to run on the cluster."
  default     = "1.33"
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

variable "cert_arn" {
  description = "Optional existing ACM certificate ARN. If provided, will skip creating a new certificate."
  type        = string
  default     = null
}

variable "enable_ses" {
  description = "Enable SES for SMTP configuration. If true, creates SES resources and uses their outputs for SMTP. If false, uses provided SMTP variables."
  type        = bool
  default     = false
}