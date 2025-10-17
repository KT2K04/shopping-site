#!/bin/bash

# 🚀 DevSecOps Quick Start Script
# This script will help you get started with the DevSecOps pipeline

echo "🛡️ DevSecOps Pipeline Quick Start"
echo "=================================="

# Check if required tools are installed
echo "📋 Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker Desktop."
    exit 1
else
    echo "✅ Docker is installed"
fi

# Check kubectl
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is not installed. Please install kubectl."
    exit 1
else
    echo "✅ kubectl is installed"
fi

# Check Helm
if ! command -v helm &> /dev/null; then
    echo "❌ Helm is not installed. Please install Helm."
    exit 1
else
    echo "✅ Helm is installed"
fi

# Check Terraform
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install Terraform."
    exit 1
else
    echo "✅ Terraform is installed"
fi

echo ""
echo "🔧 Setting up infrastructure..."

# Navigate to Terraform directory
cd infra/terraform

# Copy example variables if not exists
if [ ! -f "terraform.tfvars" ]; then
    echo "📝 Creating terraform.tfvars from example..."
    cp terraform.tfvars.example terraform.tfvars
    echo "✅ terraform.tfvars created. You can edit it if needed."
fi

# Initialize Terraform
echo "🏗️ Initializing Terraform..."
terraform init

# Plan infrastructure
echo "📋 Planning infrastructure deployment..."
terraform plan

# Ask for confirmation
echo ""
read -p "🤔 Do you want to deploy the infrastructure? (y/n): " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Deploying infrastructure..."
    terraform apply -auto-approve
    
    echo ""
    echo "📦 Deploying microservices..."
    cd ../..
    kubectl apply -f k8s/
    
    echo ""
    echo "⏳ Waiting for deployments to be ready..."
    kubectl wait --for=condition=ready pod -l app=api-gateway -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=user-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=order-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=inventory-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=notification-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=frontend -n shopping-app --timeout=300s
    
    echo ""
    echo "✅ Deployment completed!"
    echo ""
    echo "📊 Checking deployment status..."
    kubectl get pods -n shopping-app
    kubectl get services -n shopping-app
    
    echo ""
    echo "🌐 To access the application:"
    echo "1. Port forward the frontend: kubectl port-forward service/frontend-service 3005:3000 -n shopping-app"
    echo "2. Port forward the API: kubectl port-forward service/api-gateway-service 3000:3000 -n shopping-app"
    echo "3. Open browser: http://localhost:3005"
    
    echo ""
    echo "🔍 To check security features:"
    echo "- kubectl get networkpolicy -n shopping-app"
    echo "- kubectl describe pod -l app=api-gateway -n shopping-app"
    
    echo ""
    echo "🧪 To test the CI/CD pipeline:"
    echo "1. Make a code change"
    echo "2. Commit and push: git add . && git commit -m 'Test pipeline' && git push"
    echo "3. Check GitHub Actions tab"
    
else
    echo "❌ Infrastructure deployment cancelled."
fi

echo ""
echo "📚 For detailed instructions, see:"
echo "- SETUP_GUIDE.md"
echo "- TESTING_GUIDE.md"
echo "- DEVSECOPS_PIPELINE.md"
echo ""
echo "🎉 DevSecOps pipeline is ready!"
