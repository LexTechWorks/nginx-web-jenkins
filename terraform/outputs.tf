# Outputs for important resource information

output "ecr_repository_url" {
  description = "ECR repository URL"
  value       = aws_ecr_repository.nginx-web-site.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.nginx_cluster.name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = aws_ecs_cluster.nginx_cluster.arn
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.nginx_service.name
}

output "task_definition_arn" {
  description = "Task definition ARN"
  value       = aws_ecs_task_definition.nginx_task.arn
}

output "task_definition_family" {
  description = "Task definition family"
  value       = aws_ecs_task_definition.nginx_task.family
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.nginx_logs.name
}

output "iam_execution_role_arn" {
  description = "ECS task execution role ARN"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "iam_task_role_arn" {
  description = "ECS task role ARN"
  value       = aws_iam_role.ecs_task_role.arn
}

# Pipeline VPC Outputs
output "pipeline_vpc_id" {
  description = "Pipeline VPC ID"
  value       = data.aws_vpc.pipeline_vpc.id
}

output "pipeline_public_subnet_1a" {
  description = "Pipeline public subnet 1a ID"
  value       = data.aws_subnet.pipeline_public_1a.id
}

output "pipeline_public_subnet_1b" {
  description = "Pipeline public subnet 1b ID"
  value       = data.aws_subnet.pipeline_public_1b.id
}

output "pipeline_security_group_id" {
  description = "Pipeline security group ID (used for ECS tasks)"
  value       = data.aws_security_group.pipeline_sg.id
}