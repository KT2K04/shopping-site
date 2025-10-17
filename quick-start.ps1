# 🚀 DevSecOps Quick Start Script for Windows

Write-Host "🛡️ DevSecOps Pipeline Quick Start" -ForegroundColor Green

try { docker --version | Out-Null } catch { Write-Host "Install Docker" -ForegroundColor Red; exit 1 }
try { kubectl version --client | Out-Null } catch { Write-Host "Install kubectl" -ForegroundColor Red; exit 1 }
try { helm version | Out-Null } catch { Write-Host "Install Helm" -ForegroundColor Red; exit 1 }
try { terraform --version | Out-Null } catch { Write-Host "Install Terraform" -ForegroundColor Red; exit 1 }

Set-Location "infra/terraform"
if (!(Test-Path "terraform.tfvars")) { Copy-Item "terraform.tfvars.example" "terraform.tfvars" }

terraform init
terraform plan
$confirm = Read-Host "Deploy infrastructure? (y/n)"
if ($confirm -match '^(y|Y)$') {
  terraform apply -auto-approve
  Set-Location "../.."
  kubectl apply -f k8s/
  kubectl wait --for=condition=ready pod -l app=api-gateway -n shopping-app --timeout=300s
  kubectl wait --for=condition=ready pod -l app=user-service -n shopping-app --timeout=300s
  kubectl wait --for=condition=ready pod -l app=order-service -n shopping-app --timeout=300s
  kubectl wait --for=condition=ready pod -l app=inventory-service -n shopping-app --timeout=300s
  kubectl wait --for=condition=ready pod -l app=notification-service -n shopping-app --timeout=300s
  kubectl wait --for=condition=ready pod -l app=frontend -n shopping-app --timeout=300s
  kubectl get pods -n shopping-app
  kubectl get services -n shopping-app
  Write-Host "Open http://localhost:3005 after port-forwarding" -ForegroundColor Cyan
}


