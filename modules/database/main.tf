resource "random_password" "db_password" {
  length  = 32
  special = false
}

# DB subnet group
resource "aws_db_subnet_group" "flows" {
  name       = "flows-db-subnet-group"
  subnet_ids = var.subnet_ids
}

# RDS Aurora cluster
resource "aws_rds_cluster" "flows" {
  cluster_identifier              = "flows-cluster"
  engine                          = "aurora-postgresql"
  engine_version                  = "16.6"
  database_name                   = "flows"
  master_username                 = "flows"
  master_password                 = random_password.db_password.result
  backup_retention_period         = 7
  db_subnet_group_name            = aws_db_subnet_group.flows.name
  vpc_security_group_ids          = var.database_security_group_ids
  storage_encrypted               = true
  kms_key_id                      = var.kms_key_arn
  enabled_cloudwatch_logs_exports = ["postgresql"]
  apply_immediately               = true
  skip_final_snapshot             = true
  deletion_protection             = var.database_delete_protection_enabled
}

resource "aws_rds_cluster_instance" "flows" {
  identifier         = var.rds_cluster_configuration.instance_identifier
  cluster_identifier = aws_rds_cluster.flows.id
  instance_class     = var.rds_cluster_configuration.instance_class
  engine             = aws_rds_cluster.flows.engine
  engine_version     = aws_rds_cluster.flows.engine_version
}

# Store database credentials in Secrets Manager (optional, for better security)
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "flows-db-credentials"
  recovery_window_in_days = 7
  kms_key_id              = var.kms_key_id
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = aws_rds_cluster.flows.master_username
    password = random_password.db_password.result
    engine   = "postgres"
    host     = aws_rds_cluster.flows.endpoint
    port     = 5432
    dbname   = aws_rds_cluster.flows.database_name
  })
}
