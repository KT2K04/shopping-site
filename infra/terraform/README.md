# Infrastructure as Code (IaC) for Shopping Website Microservices

This directory contains Terraform configuration for deploying the shopping website microservices infrastructure to a local Kubernetes cluster.

## 🏗️ What is Infrastructure as Code (IaC)?

Infrastructure as Code (IaC) is the practice of managing and provisioning infrastructure through machine-readable definition files, rather than through physical hardware configuration or interactive configuration tools.

### Benefits of IaC:

1. **Reproducibility**: Same infrastructure can be created anywhere
2. **Version Control**: Infrastructure changes are tracked in Git
3. **Auditability**: All infrastructure changes are documented
4. **Consistency**: Eliminates manual configuration drift
5. **Collaboration**: Team members can review and approve infrastructure changes
6. **Automation**: Reduces human error and speeds up deployments
7. **Disaster Recovery**: Infrastructure can be quickly recreated

## 📁 Directory Structure

```
infra/terraform/
├── main.tf              # Main Terraform configuration
├── variables.tf          # Variable definitions
├── outputs.tf           # Output definitions
├── terraform.tfvars.example # Example variables file
└── README.md            # This file
```

## 🚀 Quick Start

### Prerequisites

1. **Terraform** (>= 1.0): [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
2. **Kubernetes cluster**: Local cluster using kind, minikube, or Docker Desktop
3. **kubectl**: [Install kubectl](https://kubernetes.io/docs/tasks/tools/)
4. **Helm**: [Install Helm](https://helm.sh/docs/intro/install/)

### Setup Instructions

1. **Clone and navigate to the terraform directory:**
   ```bash
   cd infra/terraform
   ```

2. **Copy the example variables file:**
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. **Edit the variables file with your values:**
   ```bash
   # Edit terraform.tfvars with your specific configuration
   nano terraform.tfvars
   ```

4. **Initialize Terraform:**
   ```bash
   terraform init
   ```

5. **Review the planned changes:**
   ```bash
   terraform plan
   ```

6. **Apply the infrastructure:**
   ```bash
   terraform apply
   ```

7. **Verify the deployment:**
   ```bash
   kubectl get namespaces
   kubectl get pods -n shopping-app
   ```

## 🔧 Configuration

### Key Components Created

1. **Kubernetes Namespace**: Isolated environment for the application
2. **ConfigMap**: Application configuration
3. **Secrets**: Sensitive data (JWT keys, passwords)
4. **ServiceAccount**: Identity for the application
5. **RBAC**: Role-based access control
6. **RabbitMQ**: Message broker via Helm chart
7. **NGINX Ingress**: External access controller
8. **NetworkPolicy**: Security policies

### Security Features

- **Non-root containers**: All containers run as non-root user
- **Read-only filesystem**: Containers use read-only root filesystem
- **Resource limits**: CPU and memory limits enforced
- **Network policies**: Restricted network access
- **RBAC**: Least privilege access control
- **Secrets management**: Secure handling of sensitive data

## 📊 Monitoring and Observability

The infrastructure includes:

- **Health checks**: Liveness and readiness probes
- **Resource monitoring**: CPU and memory usage tracking
- **Log aggregation**: Centralized logging setup
- **Metrics collection**: Application and infrastructure metrics

## 🔄 Lifecycle Management

### Update Infrastructure

```bash
# Make changes to .tf files
terraform plan    # Review changes
terraform apply   # Apply changes
```

### Destroy Infrastructure

```bash
terraform destroy  # Remove all created resources
```

### State Management

```bash
terraform state list                    # List all resources
terraform state show <resource_name>   # Show resource details
terraform state mv <old> <new>         # Move resource in state
```

## 🛡️ Security Best Practices

1. **Secrets Management**: Use Kubernetes secrets for sensitive data
2. **Network Security**: Implement network policies
3. **RBAC**: Use least privilege principle
4. **Container Security**: Non-root, read-only filesystem
5. **Resource Limits**: Prevent resource exhaustion
6. **Regular Updates**: Keep charts and images updated

## 🔍 Troubleshooting

### Common Issues

1. **Kubernetes connection issues:**
   ```bash
   kubectl cluster-info
   kubectl get nodes
   ```

2. **Helm chart issues:**
   ```bash
   helm list -A
   helm status <release-name>
   ```

3. **Resource conflicts:**
   ```bash
   kubectl get all -n shopping-app
   kubectl describe <resource> -n shopping-app
   ```

### Debug Commands

```bash
# Check Terraform state
terraform show

# Check Kubernetes resources
kubectl get all -n shopping-app

# Check Helm releases
helm list -A

# View logs
kubectl logs -n shopping-app -l app=shopping-website
```

## 📚 Additional Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)
- [Infrastructure as Code Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

## 🤝 Contributing

When making changes to the infrastructure:

1. Test changes in a development environment first
2. Update documentation for any new variables or outputs
3. Follow security best practices
4. Document any breaking changes
5. Update version numbers for Helm charts

## 📝 Notes

- This configuration is designed for local development and demonstration
- For production use, consider using a managed Kubernetes service
- Update secrets and passwords before deploying to production
- Monitor resource usage and adjust limits as needed
- Regular security audits and updates are recommended
