resource "aws_security_group" "database" {
  count       = length(var.database_security_group_ids) > 0 ? 0 : 1
  name        = "flows-database"
  description = "Security group for Flows database"
  vpc_id      = local.vpc_id
}

# Allow the cluster nodes to access the database.
resource "aws_vpc_security_group_ingress_rule" "cluster_database_ingress_rule" {
  count = var.enable_eks_cluster ? 1 : 0

  security_group_id = local.database_security_group_ids[0]

  description                  = "Only accept TCP connections on appropriate port from EKS cluster nodes"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.eks[0].cluster_primary_security_group_id
}


