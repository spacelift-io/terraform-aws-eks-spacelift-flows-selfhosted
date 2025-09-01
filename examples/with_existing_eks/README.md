# Existing EKS Cluster Example

This example demonstrates how to deploy Spacelift Flows to an existing EKS cluster instead of creating a new one.

## Prerequisites

- An existing EKS cluster with appropriate node groups and capacity
- Proper IAM permissions to deploy workloads to the cluster

## Usage

1. Configure your settings in a `terraform.tfvars` file:

```hcl
app_domain        = "flows.example.com"
organization_name = "Your Organization"
admin_email       = "admin@example.com"
aws_region        = "us-east-1"
license_token     = "your-license-token"
k8s_namespace     = "spacelift-flows"

# Existing EKS Configuration
enable_eks_cluster = false
eks_cluster_name   = "my-existing-cluster"
```

2. Deploy the infrastructure:

```bash
tofu init
tofu plan
tofu apply
```