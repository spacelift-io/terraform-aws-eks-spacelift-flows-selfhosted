variable "cluster_name" {
  type = string
}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0"

  name = "flows-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = 1
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = 1
  }

  enable_nat_gateway = true
  single_nat_gateway = true # Cost optimization

  enable_dns_hostnames = true
  enable_dns_support   = true
}
