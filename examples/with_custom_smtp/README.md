# Custom SMTP Configuration Example

This example demonstrates how to deploy Spacelift Flows with custom SMTP server settings for email notifications.

## Usage

1. Configure your SMTP settings in a `terraform.tfvars` file:

```hcl
app_domain        = "flows.example.com"
organization_name = "Your Organization"
admin_email       = "admin@example.com"
aws_region        = "us-east-1"
license_token     = "your-license-token"
k8s_namespace     = "spacelift-flows"

# Custom SMTP Configuration
smtp_host         = "smtp.gmail.com"
smtp_port         = 587
smtp_username     = "your-email@gmail.com"
smtp_password     = "your-app-password"
smtp_from_address = "noreply@example.com"
smtp_from_name    = "Spacelift Flows"
smtp_encryption   = "starttls"
```

2. Deploy the infrastructure:

```bash
tofu init
tofu plan
tofu apply
```

This configuration will use your custom SMTP server for sending email notifications.