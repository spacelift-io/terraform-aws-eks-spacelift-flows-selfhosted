# Existing RDS Database Example

This example demonstrates how to deploy Spacelift Flows using an existing PostgreSQL database instead of creating a new RDS instance.

## Prerequisites

- An existing PostgreSQL database (version 12+)
- Database accessible from the EKS cluster subnets
- Database user with appropriate permissions to create tables and manage the schema
- Connection details (host, port, database name, credentials)

## Database Setup

Ensure your existing database has:
- A dedicated database for Spacelift Flows
- A user with full privileges on that database
- Network connectivity from the EKS cluster

## Usage

1. Configure your settings in a `terraform.tfvars` file:

```hcl
app_domain        = "flows.example.com"
organization_name = "Your Organization"
admin_email       = "admin@example.com"
aws_region        = "us-east-1"
license_token     = "your-license-token"
k8s_namespace     = "spacelift-flows"

# Existing RDS Configuration
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
- Consider using IAM database authentication for enhanced security

This configuration will connect Spacelift Flows to your existing database without creating new RDS resources.