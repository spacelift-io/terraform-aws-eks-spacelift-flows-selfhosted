# Existing VPC Example

This example demonstrates how to deploy Spacelift Flows using an existing VPC instead of creating a new one.

## Prerequisites

- An existing VPC with appropriate CIDR blocks
- Private subnets for RDS instances and EKS worker nodes
- Public subnets for load balancers and NAT gateways
- Security groups configured for database access
- Internet Gateway and NAT Gateway properly configured

## Usage

1. Configure your settings in a `terraform.tfvars` file:

```hcl
app_domain        = "flows.example.com"
organization_name = "Your Organization"
admin_email       = "admin@example.com"
aws_region        = "us-east-1"
license_token     = "your-license-token"
k8s_namespace     = "spacelift-flows"

# Existing VPC Configuration
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
```

2. Deploy the infrastructure:

```bash
tofu init
tofu plan
tofu apply
```

This configuration will deploy Spacelift Flows into your existing VPC infrastructure without creating new networking resources.