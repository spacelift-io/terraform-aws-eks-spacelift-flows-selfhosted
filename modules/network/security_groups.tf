# Security group for database access
resource "aws_security_group" "database" {
  name        = "flows-database"
  description = "Security group for Flows database"
  vpc_id      = module.vpc.vpc_id
}

# Allow egress from database (for updates, etc.)
resource "aws_security_group_rule" "database_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.database.id
}