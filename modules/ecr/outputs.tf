output "repository_url" {
  description = "The URL of the ECR repository for Flows images"
  value       = aws_ecr_repository.flows_images.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository for Flows images"
  value       = aws_ecr_repository.flows_images.arn
}

output "repository_name" {
  description = "The name of the ECR repository for Flows images"
  value       = aws_ecr_repository.flows_images.name
}

output "registry_id" {
  description = "The registry ID where the repository was created"
  value       = aws_ecr_repository.flows_images.registry_id
}

output "agent_repository_url" {
  description = "The URL of the ECR repository for Agent images"
  value       = aws_ecr_repository.agent_images.repository_url
}

output "agent_repository_arn" {
  description = "The ARN of the ECR repository for Agent images"
  value       = aws_ecr_repository.agent_images.arn
}

output "agent_repository_name" {
  description = "The name of the ECR repository for Agent images"
  value       = aws_ecr_repository.agent_images.name
}