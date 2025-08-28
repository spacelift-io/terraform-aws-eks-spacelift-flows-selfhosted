output "connection_url" {
  description = "PostgreSQL connection URL"
  value       = "postgres://${aws_rds_cluster.flows.master_username}:${urlencode(random_password.db_password.result)}@${aws_rds_cluster.flows.endpoint}:5432/${aws_rds_cluster.flows.database_name}"
  sensitive   = true
}

output "access_policies" {
  description = "IAM policy statements for database access"
  value = {
    can_access_database_secret = {
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = [aws_secretsmanager_secret.db_credentials.arn]
    }
  }
}
