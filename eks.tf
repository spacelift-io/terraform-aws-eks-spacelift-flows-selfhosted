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

  node_security_group_additional_rules = var.eks_node_security_group_additional_rules

  compute_config          = var.eks_compute_config
  eks_managed_node_groups = var.eks_managed_node_groups
  addons                  = var.eks_addons

  tags = {
    Name = "Spacelift cluster ${local.unique_suffix}"
  }
}

# Allow the cluster nodes to access the database.
resource "aws_vpc_security_group_ingress_rule" "cluster_database_ingress_rule" {
  count = var.enable_eks_cluster ? 1 : 0

  security_group_id = local.database_security_group_ids[0]

  description                  = "Only accept TCP connections on appropriate port from EKS cluster nodes"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.eks_compute_config != null ? module.eks[0].cluster_primary_security_group_id : module.eks[0].node_security_group_id
}


