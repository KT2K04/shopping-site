# 🚀 DevSecOps Quick Start Script for Windows
# This PowerShell script will help you get started with the DevSecOps pipeline

Write-Host "🛡️ DevSecOps Pipeline Quick Start" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Green

# Check if required tools are installed
Write-Host "📋 Checking prerequisites..." -ForegroundColor Yellow

# Check Docker
try {
    docker --version | Out-Null
    Write-Host "✅ Docker is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Docker is not installed. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check kubectl
try {
    kubectl version --client | Out-Null
    Write-Host "✅ kubectl is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ kubectl is not installed. Please install kubectl." -ForegroundColor Red
    exit 1
}

# Check Helm
try {
    helm version | Out-Null
    Write-Host "✅ Helm is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Helm is not installed. Please install Helm." -ForegroundColor Red
    exit 1
}

# Check Terraform
try {
    terraform --version | Out-Null
    Write-Host "✅ Terraform is installed" -ForegroundColor Green
} catch {
    Write-Host "❌ Terraform is not installed. Please install Terraform." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔧 Setting up infrastructure..." -ForegroundColor Yellow

# Navigate to Terraform directory
Set-Location "infra/terraform"

# Copy example variables if not exists
if (!(Test-Path "terraform.tfvars")) {
    Write-Host "📝 Creating terraform.tfvars from example..." -ForegroundColor Yellow
    Copy-Item "terraform.tfvars.example" "terraform.tfvars"
    Write-Host "✅ terraform.tfvars created. You can edit it if needed." -ForegroundColor Green
}

# Initialize Terraform
Write-Host "🏗️ Initializing Terraform..." -ForegroundColor Yellow
terraform init

# Plan infrastructure
Write-Host "📋 Planning infrastructure deployment..." -ForegroundColor Yellow
terraform plan

# Ask for confirmation
Write-Host ""
$confirmation = Read-Host "🤔 Do you want to deploy the infrastructure? (y/n)"
if ($confirmation -eq 'y' -or $confirmation -eq 'Y') {
    Write-Host "🚀 Deploying infrastructure..." -ForegroundColor Yellow
    terraform apply -auto-approve
    
    Write-Host ""
    Write-Host "📦 Deploying microservices..." -ForegroundColor Yellow
    Set-Location "../.."
    kubectl apply -f k8s/
    
    Write-Host ""
    Write-Host "⏳ Waiting for deployments to be ready..." -ForegroundColor Yellow
    kubectl wait --for=condition=ready pod -l app=api-gateway -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=user-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=order-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=inventory-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=notification-service -n shopping-app --timeout=300s
    kubectl wait --for=condition=ready pod -l app=frontend -n shopping-app --timeout=300s
    
    Write-Host ""
    Write-Host "✅ Deployment completed!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📊 Checking deployment status..." -ForegroundColor Yellow
    kubectl get pods -n shopping-app
    kubectl get services -n shopping-app
    
    Write-Host ""
    Write-Host "🌐 To access the application:" -ForegroundColor Cyan
    Write-Host "1. Port forward the frontend: kubectl port-forward service/frontend-service 3005:3000 -n shopping-app" -ForegroundColor White
    Write-Host "2. Port forward the API: kubectl port-forward service/api-gateway-service 3000:3000 -n shopping-app" -ForegroundColor White
    Write-Host "3. Open browser: http://localhost:3005" -ForegroundColor White
    
    Write-Host ""
    Write-Host "🔍 To check security features:" -ForegroundColor Cyan
    Write-Host "- kubectl get networkpolicy -n shopping-app" -ForegroundColor White
    Write-Host "- kubectl describe pod -l app=api-gateway -n shopping-app" -ForegroundColor White
    
    Write-Host ""
    Write-Host "🧪 To test the CI/CD pipeline:" -ForegroundColor Cyan
    Write-Host "1. Make a code change" -ForegroundColor White
    Write-Host "2. Commit and push: git add . && git commit -m 'Test pipeline' && git push" -ForegroundColor White
    Write-Host "3. Check GitHub Actions tab" -ForegroundColor White
    
} else {
    Write-Host "❌ Infrastructure deployment cancelled." -ForegroundColor Red
}

Write-Host ""
Write-Host "📚 For detailed instructions, see:" -ForegroundColor Cyan
Write-Host "- SETUP_GUIDE.md" -ForegroundColor White
Write-Host "- TESTING_GUIDE.md" -ForegroundColor White
Write-Host "- DEVSECOPS_PIPELINE.md" -ForegroundColor White
Write-Host ""
Write-Host "🎉 DevSecOps pipeline is ready!" -ForegroundColor Green
