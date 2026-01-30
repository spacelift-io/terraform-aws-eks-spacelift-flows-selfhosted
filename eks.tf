resource "random_uuid" "suffix" {
}


module "eks" {
  count   = var.enable_eks_cluster ? 1 : 0
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.cluster_name
  kubernetes_version = var.eks_cluster_version

  # The Kubernetes API endpoint will be accessible via the public internet.
  endpoint_public_access = true

  # Adds the current caller identity as an administrator via cluster access entry. This is required
  # in order to install the cluster addons.
  enable_cluster_creator_admin_permissions = true

  vpc_id     = local.vpc_id
  subnet_ids = local.private_subnet_ids

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  tags = {
    Name = "Spacelift cluster ${local.unique_suffix}"
  }
}

