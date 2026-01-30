# Security group for database access
resource "aws_security_group" "database" {
  name        = "flows-database"
  description = "Security group for Flows database"
  vpc_id      = module.vpc.vpc_id
}