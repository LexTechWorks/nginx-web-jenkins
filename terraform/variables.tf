# Variables for Terraform Configuration

variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "nginx-web-site"
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "833371734412"
}

variable "cluster_name" {
  description = "ECS Cluster name"
  type        = string
  default     = "nginx-web-site-cluster"
}

variable "service_name" {
  description = "ECS Service name"
  type        = string
  default     = "nginx-web-site-task-service-b2igefhw"
}

variable "task_family" {
  description = "ECS Task Definition family"
  type        = string
  default     = "nginx-web-site-task"
}

variable "ecr_repository" {
  description = "ECR Repository name"
  type        = string
  default     = "nginx-web-site"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}

variable "task_cpu" {
  description = "Task CPU units"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Task memory (MiB)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

# Pipeline VPC Configuration
variable "pipeline_vpc_name" {
  description = "Name of the Pipeline VPC"
  type        = string
  default     = "Pipeline - Project-vpc"
}

variable "pipeline_security_group_name" {
  description = "Name of the Pipeline Security Group"
  type        = string
  default     = "SG-pipeline-project"
}