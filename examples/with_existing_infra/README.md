# Existing Infrastructure Example

This example demonstrates how to deploy Spacelift Flows using existing AWS infrastructure components (VPC, EKS cluster, and database) instead of creating new ones.

## Prerequisites

This example combines all the existing infrastructure scenarios and requires:

### Existing VPC
- VPC with appropriate CIDR blocks
- Private subnets for RDS instances and EKS worker nodes
- Public subnets for load balancers and NAT gateways
- Security groups configured for database access
- Internet Gateway and NAT Gateway properly configured

### Existing EKS Cluster
- EKS cluster with appropriate node groups and capacity
- Proper IAM permissions to deploy workloads to the cluster
- kubectl access to the cluster configured

### Existing Database
- PostgreSQL database (version 16+)
- Database accessible from the EKS cluster subnets
- Database user with appropriate permissions
- Connection details (host, port, database name, credentials)

## Usage

1. Configure your settings in a `terraform.tfvars` file:

```hcl
app_domain        = "flows.example.com"
organization_name = "Your Organization"
admin_email       = "admin@example.com"
aws_region        = "us-east-1"
license_token     = "your-license-token"
k8s_namespace     = "spacelift-flows"

# Existing Infrastructure Configuration
enable_eks_cluster = false
eks_cluster_name   = "my-existing-cluster"

enable_vpc = false
vpc_id     = "vpc-1234567890abcdef0"

private_subnet_ids = [
  "subnet-1234567890abcdef0",
  "subnet-1234567890abcdef1"
]

public_subnet_ids = [
  "subnet-abcdef0123456789",
  "subnet-abcdef0123456790"
]

database_security_group_ids = [
  "sg-1234567890abcdef0"
]

enable_database         = false
database_connection_url = "postgres://flowsuser:securepassword@your-db-host.amazonaws.com:5432/spacelift_flows"
```

2. Deploy the infrastructure:

```bash
tofu init
tofu plan
tofu apply
```
## Security Notes

- The database connection URL contains sensitive credentials and will be stored as a Kubernetes secret
- Ensure your database is configured with appropriate security groups to allow connections from the EKS cluster
- Verify that your EKS cluster has the necessary IAM permissions for Spacelift Flows workloads

This configuration will deploy Spacelift Flows using all your existing AWS infrastructure without creating any new networking, compute, or database resources.