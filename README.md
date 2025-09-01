# Terraform AWS EKS Spacelift Flows Self-hosted

A comprehensive Terraform module for deploying Spacelift Flows on AWS using Amazon EKS. This module provides a complete infrastructure setup with flexible configuration options to accommodate various deployment scenarios.

## Features

- **Complete Infrastructure Setup**: VPC, EKS cluster, RDS database, S3 buckets, and all necessary AWS resources
- **Flexible Configuration**: Use existing infrastructure or create new resources as needed
- **Security Best Practices**: KMS encryption, secure networking, IAM roles with least privilege
- **Multiple SMTP Options**: Support for AWS SES or custom SMTP servers
- **SSL/TLS Support**: Automatic ACM certificate creation or use existing certificates
- **Production Ready**: Configurable deletion protection, backup retention, and monitoring support

## Architecture

This module deploys:

- **EKS Cluster**: Kubernetes cluster for running Spacelift Flows workloads
- **VPC & Networking**: Private and public subnets across multiple AZs with security groups
- **RDS Database**: PostgreSQL database for Spacelift Flows data storage
- **S3 Buckets**: Object storage for flow artifacts and logs
- **KMS Encryption**: Customer-managed keys for encrypting data at rest
- **IAM Roles**: Properly scoped service accounts and permissions

## Quick Start

### Basic Usage

```hcl
module "spacelift_flows" {
  source = "github.com/spacelift-io/terraform-aws-eks-spacelift-flows-selfhosted?ref=main"

  # Required variables
  app_domain        = "flows.example.com"
  organization_name = "Your Organization"
  admin_email       = "admin@example.com"
  aws_region        = "us-east-1"
  license_token     = "your-spacelift-flows-license-token"
}
```

### With Custom Configuration

```hcl
module "spacelift_flows" {
  source = "github.com/spacelift-io/terraform-aws-eks-spacelift-flows-selfhosted?ref=main"

  # Required variables
  app_domain        = "flows.example.com"
  organization_name = "Your Organization"
  admin_email       = "admin@example.com"
  aws_region        = "us-east-1"
  license_token     = "your-spacelift-flows-license-token"

  # Optional customizations
  k8s_namespace               = "spacelift-flows"
  eks_cluster_version         = "1.33"
  rds_delete_protection_enabled = false
  s3_retain_on_destroy        = false
  
  # SMTP configuration (choose one option)
  enable_ses = true  # Use AWS SES
  # OR use custom SMTP
  # smtp_host = "smtp.gmail.com"
  # smtp_username = "your-email@gmail.com"
  # smtp_password = "your-app-password"
  # smtp_from_address = "noreply@example.com"
}
```

## Examples

This repository includes several examples demonstrating different deployment scenarios:

### [Basic Deployment](examples/)
Standard deployment creating all new infrastructure.

### [Custom SMTP Configuration](examples/with_custom_smtp/)
Deploy with custom SMTP server instead of AWS SES.

### [Custom SSL Certificate](examples/with_custom_cert/)
Use an existing ACM certificate instead of creating a new one.

### [Existing EKS Cluster](examples/with_existing_eks/)
Deploy to an existing EKS cluster without creating new compute resources.

### [Existing VPC](examples/with_existing_vpc/)
Use existing VPC and networking infrastructure.

### [Existing RDS Database](examples/with_existing_rds/)
Connect to an existing PostgreSQL database.

### [Existing Infrastructure](examples/with_existing_infra/)
Deploy using entirely existing AWS infrastructure (VPC, EKS, and database).

## Deployment Steps

1. **Configure Variables**: Create a `terraform.tfvars` file with your configuration
2. **Initialize**: Run `tofu init` to initialize the module
3. **Plan**: Run `tofu plan` to review the planned changes
4. **Apply**: Run `tofu apply` to create the infrastructure
5. **Deploy to Kubernetes**: Apply the generated manifests to your cluster

```bash
# Initialize and apply infrastructure
tofu init
tofu plan
tofu apply

# Deploy to Kubernetes cluster
kubectl apply -f <(echo "$(tofu output -raw config_secret_manifest)")
kubectl apply -f <(echo "$(tofu output -raw ingress_manifest)")
kubectl apply -f <(echo "$(tofu output -raw agent_pool_secret_manifest)")
```


## Requirements

- OpenTofu >= 1.5.0
- AWS Provider >= 6.0
- Sufficient AWS permissions to create VPC, EKS, RDS, S3, and IAM resources
- kubectl configured for Kubernetes manifest deployment


## 🚀 Release

To release a new version of the module, just create a new release with an appropriate tag in GitHub releases.
