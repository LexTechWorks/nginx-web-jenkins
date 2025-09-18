# CI/CD Pipeline - Nginx Web Application

![Pipeline Status](https://img.shields.io/badge/Pipeline-Active-green)
![AWS](https://img.shields.io/badge/AWS-ECS%20%7C%20ECR%20%7C%20Fargate-orange)
![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-purple)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-blue)

Complete CI/CD pipeline demonstrating DevOps best practices with infrastructure as code, quality analysis, containerization, and automated AWS deployment.

## Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Technologies](#technologies)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [Configuration](#configuration)
- [Pipelines](#pipelines)
- [Infrastructure](#infrastructure)
- [Monitoring](#monitoring)
- [Maintenance](#maintenance)

## Overview

This project implements an enterprise-grade CI/CD pipeline for a nginx web application, featuring:

- **Containerization** with Docker
- **Quality Analysis** with SonarQube
- **Infrastructure as Code** with Terraform
- **AWS Deployment** with ECS Fargate
- **Automated CI/CD** with Jenkins
- **Security Best Practices**

### Features

- Web application serving custom nginx page
- CloudWatch metrics and monitoring
- Automated code quality analysis
- Zero-downtime deployments

## Architecture

```
GitHub Repository → Jenkins Pipeline → SonarQube Analysis → Quality Gate
                                   ↓
Docker Build → AWS ECR → Terraform Apply → ECS Fargate → Running Application
                                   ↓
                               AWS S3 (Terraform State)
                                   ↓
                            CloudWatch (Logs & Metrics)
```

### Components

| Component | Function | Technology |
|-----------|----------|------------|
| Source Control | Code versioning | GitHub |
| CI/CD | Build and deployment automation | Jenkins |
| Quality Gate | Code analysis | SonarQube |
| Containerization | Application packaging | Docker |
| Container Registry | Image storage | AWS ECR |
| Infrastructure | Resource provisioning | Terraform |
| Orchestration | Container execution | AWS ECS Fargate |
| Monitoring | Logs and metrics | AWS CloudWatch |
| State Management | Terraform remote state | AWS S3 |

## Technologies

### Infrastructure & Backend
- **Terraform** >= 1.0 - Infrastructure as Code
- **AWS Provider** 5.100.0 - AWS resources
- **AWS CLI** >= 2.0 - Command line interface

### CI/CD & Quality
- **Jenkins** >= 2.400 - Automation server
- **SonarQube** >= 9.0 - Code quality analysis
- **Docker** >= 20.0 - Containerization

### AWS Services
- **ECS Fargate** - Container orchestration
- **ECR** - Container registry
- **S3** - Terraform state storage
- **CloudWatch** - Logging and monitoring
- **IAM** - Identity and access management
- **VPC** - Network isolation

## Project Structure

```
project-pipeline-web-site/
├── README.md                    # Documentation
├── Dockerfile                   # Application container
├── index.html                   # Web application
├── .gitignore                   # Git ignored files
├── LICENSE                      # MIT License
│
├── Jenkins Pipelines
│   ├── jenkinsfile                 # Main pipeline (deploy)
│   ├── jenkinsfile-destroy         # Safe destruction pipeline
│   ├── jenkinsfile-destroy-fast    # Fast destruction pipeline
│   └── jenkinsfile-terraform-test  # Terraform testing pipeline
│
└── terraform/                   # Infrastructure as Code
    ├── backend.tf                  # S3 backend configuration
    ├── provider.tf                 # AWS provider configuration
    ├── variables.tf                # Terraform variables
    ├── outputs.tf                  # Resource outputs
    ├── ecr.tf                      # Container repository
    ├── ecs.tf                      # ECS cluster and services
    ├── iam.tf                      # IAM roles and policies
    └── vpc.tf                      # Network configuration
```

## Quick Start

### Prerequisites

- Jenkins installed and configured
- Terraform installed on Jenkins agent
- AWS CLI configured with credentials
- Docker installed on Jenkins agent
- SonarQube configured (optional)

### Setup

```bash
# 1. Clone repository
git clone https://github.com/JoaumGabrielSS/project-pipeline-web-site.git
cd project-pipeline-web-site

# 2. Configure Terraform variables
cd terraform
# Edit variables.tf as needed

# 3. Initialize Terraform (optional - for local testing)
terraform init
terraform plan
```

### Jenkins Configuration

1. Create new job: `nginx-web-site`
2. Type: Pipeline
3. Source: SCM → Git
4. Repository: `https://github.com/JoaumGabrielSS/project-pipeline-web-site.git`
5. Script Path: `jenkinsfile`

## Configuration

### AWS Credentials

Configure AWS credentials in Jenkins:

```
Jenkins → Manage Jenkins → Credentials → Add Credentials
ID: aws-access-key
Type: AWS Credentials
Access Key ID: [YOUR_ACCESS_KEY]
Secret Access Key: [YOUR_SECRET_KEY]
```

### Terraform Variables

Key configurable variables:

```hcl
# terraform/variables.tf
variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  default     = "dev"
}

variable "project_name" {
  description = "Project name"
  default     = "nginx-web-site"
}
```

### SonarQube (Optional)

To enable quality analysis:

1. Configure SonarQube server in Jenkins
2. Install SonarQube Scanner plugin
3. Configure SonarQube credentials

## Pipelines

### Main Pipeline (`jenkinsfile`)

Complete deployment pipeline with the following stages:

1. **Checkout** - Code verification
2. **Terraform Init** - Infrastructure initialization
3. **Terraform Plan** - Change planning
4. **Approval** - Manual approval for apply
5. **Terraform Apply** - Infrastructure deployment
6. **Docker Build** - Image construction
7. **Docker Test** - Image testing
8. **SonarQube Analysis** - Quality analysis
9. **Quality Gate** - Criteria verification
10. **ECR Push** - Image upload
11. **ECS Deploy** - Fargate deployment

### Destruction Pipeline (`jenkinsfile-destroy`)

Safe infrastructure removal pipeline:

- Double confirmation for destruction
- Current state verification
- ECR cleanup before destruction
- Terraform destroy with verification
- Complete removal confirmation

### Fast Destruction (`jenkinsfile-destroy-fast`)

For emergency situations:

- Single confirmation
- Immediate destruction
- Quick cost stoppage

## Infrastructure

### Created Resources

| Resource | Description | Estimated Cost |
|----------|-------------|----------------|
| **ECS Cluster** | Container cluster | Free |
| **ECS Service** | Fargate service | ~$15/month |
| **ECR Repository** | Image registry | ~$1/month |
| **CloudWatch Logs** | Application logs | ~$1/month |
| **IAM Roles** | Permissions | Free |
| **S3 Bucket** | Terraform state | ~$1/month |

**Total estimated cost: ~$18/month**

### Resource Configuration

```hcl
# ECS Task Definition
resource "aws_ecs_task_definition" "nginx_task" {
  family                   = "nginx-web-site-task"
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                     = "256"    # 0.25 vCPU
  memory                  = "512"    # 512 MB
}

# ECS Service
resource "aws_ecs_service" "nginx_service" {
  desired_count = 1
  launch_type   = "FARGATE"
  
  network_configuration {
    assign_public_ip = true
    subnets         = [data.aws_subnet.pipeline_public_1a.id]
    security_groups = [data.aws_security_group.pipeline_sg.id]
  }
}
```

## Monitoring

### CloudWatch Metrics

- **CPU Utilization**: Container CPU usage
- **Memory Utilization**: Memory usage
- **Task Count**: Number of running tasks
- **Service Events**: ECS service events

### Logs

```bash
# View logs via AWS CLI
aws logs tail /ecs/nginx-web-site --follow --region us-east-1

# Via AWS console
# CloudWatch → Log groups → /ecs/nginx-web-site
```

### Recommended Alerts

- CPU > 80% for 5 minutes
- Memory > 90% for 5 minutes
- Task count = 0 (application offline)
- Health check failures

## Maintenance

### Infrastructure Updates

```bash
# 1. Modify .tf files
# 2. Commit and push
git add terraform/
git commit -m "feat: add new resource"
git push

# 3. Run main pipeline
# Pipeline will show changes and request approval
```

### Application Updates

```bash
# 1. Modify Dockerfile or index.html
# 2. Commit and push
git add .
git commit -m "feat: update application"
git push

# 3. Run pipeline
# New image will be created and deployed automatically
```

### Resource Cleanup

To remove everything and stop costs:

```bash
# Option 1: Safe pipeline (recommended)
# Run job: nginx-destroy

# Option 2: Fast pipeline (emergency)
# Run job: nginx-destroy-emergency

# Option 3: Manual
cd terraform
terraform destroy --auto-approve
```

## Security

### Implemented Best Practices

- **IAM Roles**: Principle of least privilege
- **ECR Scanning**: Vulnerability scanning
- **CloudWatch Logs**: Complete auditing
- **.gitignore**: Sensitive file exclusion
- **Secrets**: Management via Jenkins Credentials

### Additional Recommendations

- Enable AWS CloudTrail
- Configure AWS Config
- Implement S3 state backup
- Configure security alerts
- Periodic IAM policy review

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| `terraform init` fails | S3 backend doesn't exist | Create bucket manually |
| Deploy fails | ECR images too large | Optimize Dockerfile |
| Task doesn't start | Insufficient CPU/Memory | Adjust task definition |
| Quality Gate fails | Code doesn't meet criteria | Fix SonarQube issues |

### Support

```bash
# Jenkins logs
# Jenkins → Build → Console Output

# Application logs
aws logs tail /ecs/nginx-web-site --follow

# Resource status
terraform show
aws ecs describe-services --cluster nginx-web-site-cluster
```

## Contributing

### How to Contribute

1. Fork the repository
2. Clone your fork
3. Create a branch: `git checkout -b feature/new-feature`
4. Commit your changes: `git commit -m 'feat: add new feature'`
5. Push to branch: `git push origin feature/new-feature`
6. Open a Pull Request

### Commit Convention

```bash
feat: new functionality
fix: bug fix
docs: documentation
style: formatting
refactor: refactoring
test: tests
chore: maintenance
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Author

**Gabriel** - [@JoaumGabrielSS](https://github.com/JoaumGabrielSS)