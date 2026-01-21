# Kubernetes secret manifest with config.yaml
output "config_secret_manifest" {
  description = "Complete Kubernetes secret manifest with config.yaml"
  value = yamlencode({
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "spacelift-flows-secret"
      namespace = var.k8s_namespace
      labels = {
        "app.kubernetes.io/name"     = "spacelift-flows"
        "app.kubernetes.io/instance" = "spacelift-flows"
      }
    }
    type = "Opaque"
    data = {
      "config.yaml" = base64encode(templatefile("${path.module}/config.yaml.tftpl", {
        app_domain                       = var.app_domain
        database_url                     = var.enable_database ? module.database[0].connection_url : var.database_connection_url
        opentelemetry_collector_endpoint = var.opentelemetry_collector_endpoint
        opentelemetry_environment        = var.opentelemetry_environment
        anthropic_api_key                = var.anthropic_api_key
        s3_bucket_name                   = module.buckets.storage_bucket_name
        s3_access_key_id                 = module.buckets.s3_access_key_id
        s3_secret_access_key             = module.buckets.s3_secret_access_key
        s3_endpoint                      = "s3.${var.aws_region}.amazonaws.com"
        s3_region                        = var.aws_region
        s3_insecure                      = false
        email_dev_enabled                = var.email_dev_enabled
        smtp_host                        = var.enable_ses ? module.ses[0].smtp_server : var.smtp_host
        smtp_port                        = var.smtp_port
        smtp_username                    = var.enable_ses ? module.ses[0].smtp_username : var.smtp_username
        smtp_password                    = var.enable_ses ? module.ses[0].smtp_password : var.smtp_password
        smtp_from_address                = var.enable_ses ? module.ses[0].noreply_email : var.smtp_from_address
        smtp_from_name                   = var.smtp_from_name
        smtp_encryption                  = var.enable_ses ? "starttls" : var.smtp_encryption
        default_agent_pool_id            = random_uuid.default_agent_pool_id.result
        default_agent_pool_token         = random_password.default_agent_pool_token.result
        organization_name                = var.organization_name
        admin_email                      = var.admin_email
        server_port                      = var.server_port
        license_token                    = var.license_token
      }))
    }
  })
  sensitive = true
}

# Agent pool credentials secret manifest for Helm chart
output "agent_pool_secret_manifest" {
  description = "Kubernetes secret manifest for agent pool credentials (spacelift-spaceflows-agentpool)"
  value = yamlencode({
    apiVersion = "v1"
    kind       = "Secret"
    metadata = {
      name      = "spacelift-flows-agentpool"
      namespace = var.k8s_namespace
      labels = {
        "app.kubernetes.io/name"      = "spacelift-flows-agent"
        "app.kubernetes.io/instance"  = "spacelift-flows-agent"
        "app.kubernetes.io/component" = "agent-pool"
      }
    }
    type = "Opaque"
    stringData = {
      token   = random_password.default_agent_pool_token.result
      pool-id = random_uuid.default_agent_pool_id.result
    }
  })
  sensitive = true
}

# Ingress manifest for EKS Auto Mode ALB
output "ingress_manifest" {
  description = "Complete Kubernetes ingress manifest with dynamic subnets and certificate ARN"
  value = templatefile("${path.module}/ingress.yaml.tftpl", {
    public_subnet_ids = local.public_subnet_ids
    certificate_arn   = var.cert_arn != null ? var.cert_arn : aws_acm_certificate.flows[0].arn
  })
}

# Ingress manifest for EKS Auto Mode internal ALB
output "internal_ingress_manifest" {
  description = "Complete Kubernetes ingress manifest with dynamic subnets and certificate ARN"
  value = templatefile("${path.module}/internal_ingress.yaml.tftpl", {
    private_subnet_ids = local.private_subnet_ids
    certificate_arn    = var.cert_arn != null ? var.cert_arn : aws_acm_certificate.flows[0].arn
  })
}

output "shell" {
  description = "Environment variables for installation tasks. This output is just included as a convenience for use as part of the EKS getting started guide."
  value = templatefile("${path.module}/env.tftpl", {
    env : {
      # EKS
      EKS_CLUSTER_NAME = local.cluster_name
    },
  })
}

output "eks_cluster_name" {
  value       = local.cluster_name
  description = "Name of the EKS cluster."
}

output "eks_cluster_endpoint" {
  value       = var.enable_eks_cluster ? module.eks[0].cluster_endpoint : ""
  description = "Endpoint of the EKS cluster."
}

output "eks_cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the eks cluster"
  value       = var.enable_eks_cluster ? module.eks[0].cluster_certificate_authority_data : ""
}


output "agent_pool_token" {
  description = "The token for the default agent pool"
  value       = random_password.default_agent_pool_token.result
}

output "agent_pool_id" {
  description = "The ID of the default agent pool"
  value       = random_uuid.default_agent_pool_id.result
}


output "vpc_id" {
  description = "The ID of the VPC"
  value       = var.enable_vpc ? module.network[0].vpc_id : ""
}

output "vpc_private_subnet_ids" {
  description = "List of IDs of private subnets in the VPC"
  value       = var.enable_vpc ? module.network[0].private_subnet_ids : []
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository for Spacelift Flows images"
  value       = var.enable_ecr ? module.ecr[0].repository_url : ""
}

output "ecr_repository_arn" {
  description = "The ARN of the ECR repository for Flows images"
  value       = var.enable_ecr ? module.ecr[0].repository_arn : ""
}

output "ecr_repository_name" {
  description = "The name of the ECR repository for Flows images"
  value       = var.enable_ecr ? module.ecr[0].repository_name : ""
}

output "ecr_agent_repository_url" {
  description = "The URL of the ECR repository for Spacelift Agent images"
  value       = var.enable_ecr ? module.ecr[0].agent_repository_url : ""
}

output "ecr_agent_repository_arn" {
  description = "The ARN of the ECR repository for Agent images"
  value       = var.enable_ecr ? module.ecr[0].agent_repository_arn : ""
}

output "ecr_agent_repository_name" {
  description = "The name of the ECR repository for Agent images"
  value       = var.enable_ecr ? module.ecr[0].agent_repository_name : ""
}