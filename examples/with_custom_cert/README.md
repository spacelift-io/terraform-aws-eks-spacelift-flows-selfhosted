# Custom Certificate Example

This example demonstrates how to deploy Spacelift Flows using an existing ACM certificate instead of creating a new one.

## Usage

1. Create or import your SSL certificate in AWS Certificate Manager (ACM) in the same region where you're deploying Spacelift Flows.

2. Configure your settings in a `terraform.tfvars` file:

```hcl
app_domain        = "flows.example.com"
organization_name = "Your Organization"  
admin_email       = "admin@example.com"
aws_region        = "us-east-1"
license_token     = "your-license-token"
k8s_namespace     = "spacelift-flows"

# Custom Certificate Configuration
cert_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"
```

3. Deploy the infrastructure:

```bash
tofu init
tofu plan
tofu apply
```

This configuration will use your existing ACM certificate for SSL/TLS termination instead of creating a new certificate.