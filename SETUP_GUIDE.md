# 🚀 DevSecOps Setup Guide

## Prerequisites Installation

### 1. Install Required Tools

#### Docker Desktop
```bash
# Download and install Docker Desktop from:
# https://www.docker.com/products/docker-desktop/
```

#### Kubernetes (Choose one option)

**Option A: Docker Desktop (Recommended for Windows)**
- Enable Kubernetes in Docker Desktop settings
- Go to Settings → Kubernetes → Enable Kubernetes

**Option B: Kind (Kubernetes in Docker)**
```bash
# Install Kind
choco install kind
# or download from: https://kind.sigs.k8s.io/docs/user/quick-start/

# Create cluster
kind create cluster --name shopping-cluster
```

**Option C: Minikube**
```bash
# Install Minikube
choco install minikube
# or download from: https://minikube.sigs.k8s.io/docs/start/

# Start cluster
minikube start
```

#### kubectl
```bash
# Install kubectl
choco install kubernetes-cli
# or download from: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
```

#### Helm
```bash
# Install Helm
choco install kubernetes-helm
# or download from: https://helm.sh/docs/intro/install/
```

#### Terraform
```bash
# Install Terraform
choco install terraform
# or download from: https://www.terraform.io/downloads.html
```

### 2. Verify Installation

```bash
# Check all tools are installed
docker --version
kubectl version --client
helm version
terraform --version
```

## Environment Setup

### 1. Configure kubectl for your cluster

**For Docker Desktop:**
```bash
# kubectl should automatically connect to Docker Desktop's Kubernetes
kubectl cluster-info
```

**For Kind:**
```bash
# Set kubeconfig
kind get kubeconfig --name shopping-cluster > ~/.kube/config
kubectl cluster-info
```

**For Minikube:**
```bash
# kubectl should automatically connect to minikube
kubectl cluster-info
```

### 2. Test Kubernetes Connection
```bash
kubectl get nodes
kubectl get namespaces
```

### 3. Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets:
- `REGISTRY_USERNAME`: Your GitHub username
- `REGISTRY_PASSWORD`: Your GitHub Personal Access Token (with packages:write permission)
- `KUBECONFIG_DATA`: Base64 encoded kubeconfig

**To get KUBECONFIG_DATA:**
```bash
# Get your kubeconfig and encode it
kubectl config view --raw | base64 -w 0
# Copy the output and paste it as KUBECONFIG_DATA secret
```

## Next Steps

1. **Test the pipeline** by pushing to main branch
2. **Deploy infrastructure** using Terraform
3. **Deploy microservices** using Kubernetes manifests
4. **Verify everything works** end-to-end
