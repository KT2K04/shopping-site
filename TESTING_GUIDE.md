# 🧪 DevSecOps Pipeline Testing Guide

## Phase 1: Test Security Scanning

### 1. Test GitHub Actions Pipeline

```bash
# 1. Commit and push your changes
git add .
git commit -m "Add DevSecOps pipeline with security scanning and CI/CD"
git push origin main

# 2. Go to GitHub → Actions tab
# 3. Watch the "DevSecOps Pipeline" workflow run
# 4. Check each job:
#    - security-scan: CodeQL, npm audit, Trivy
#    - container-scan: Docker image scanning
#    - build-and-deploy: Docker builds and Kubernetes deployment
```

### 2. Verify Security Reports

```bash
# Check GitHub Security tab for:
# - Code scanning alerts (CodeQL results)
# - Dependency alerts (npm audit results)
# - Container scanning alerts (Trivy results)
```

## Phase 2: Test Infrastructure as Code

### 1. Deploy Infrastructure with Terraform

```bash
# Navigate to Terraform directory
cd infra/terraform

# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit variables (optional - defaults work for testing)
# nano terraform.tfvars

# Initialize Terraform
terraform init

# Review what will be created
terraform plan

# Apply infrastructure
terraform apply
# Type 'yes' when prompted
```

### 2. Verify Infrastructure Deployment

```bash
# Check namespace was created
kubectl get namespaces | grep shopping-app

# Check ConfigMap and Secrets
kubectl get configmap -n shopping-app
kubectl get secrets -n shopping-app

# Check Helm releases
helm list -A

# Check network policies
kubectl get networkpolicy -n shopping-app
```

## Phase 3: Test Microservices Deployment

### 1. Deploy Microservices

```bash
# Apply all Kubernetes manifests
kubectl apply -f k8s/

# Check deployment status
kubectl get pods -n shopping-app
kubectl get services -n shopping-app
kubectl get deployments -n shopping-app
```

### 2. Verify Services are Running

```bash
# Wait for all pods to be ready
kubectl wait --for=condition=ready pod -l app=api-gateway -n shopping-app --timeout=300s
kubectl wait --for=condition=ready pod -l app=user-service -n shopping-app --timeout=300s
kubectl wait --for=condition=ready pod -l app=order-service -n shopping-app --timeout=300s
kubectl wait --for=condition=ready pod -l app=inventory-service -n shopping-app --timeout=300s
kubectl wait --for=condition=ready pod -l app=notification-service -n shopping-app --timeout=300s
kubectl wait --for=condition=ready pod -l app=frontend -n shopping-app --timeout=300s

# Check pod status
kubectl get pods -n shopping-app
```

### 3. Test Application Access

```bash
# Port forward to test services locally
kubectl port-forward service/api-gateway-service 3000:3000 -n shopping-app &
kubectl port-forward service/frontend-service 3005:3000 -n shopping-app &

# Test in browser:
# - Frontend: http://localhost:3005
# - API Gateway: http://localhost:3000
```

## Phase 4: Test Security Features

### 1. Verify Security Contexts

```bash
# Check containers are running as non-root
kubectl exec -it deployment/api-gateway -n shopping-app -- id
kubectl exec -it deployment/user-service -n shopping-app -- id

# Should show uid=1000 (non-root user)
```

### 2. Test Resource Limits

```bash
# Check resource limits are applied
kubectl describe pod -l app=api-gateway -n shopping-app | grep -A 10 "Limits:"
kubectl describe pod -l app=user-service -n shopping-app | grep -A 10 "Limits:"
```

### 3. Test Network Policies

```bash
# Check network policies are applied
kubectl get networkpolicy -n shopping-app
kubectl describe networkpolicy shopping-app-network-policy -n shopping-app
```

## Phase 5: Test CI/CD Pipeline

### 1. Make a Code Change

```bash
# Make a small change to trigger pipeline
echo "// Test comment" >> api-gateway/index.js
git add .
git commit -m "Test CI/CD pipeline"
git push origin main
```

### 2. Monitor Pipeline Execution

```bash
# Go to GitHub → Actions
# Watch the pipeline run through all phases:
# 1. Security scanning
# 2. Container scanning  
# 3. Docker builds
# 4. Kubernetes deployment
```

### 3. Verify Deployment

```bash
# Check if new images were deployed
kubectl get pods -n shopping-app -o jsonpath='{.items[*].spec.containers[*].image}'

# Check rollout status
kubectl rollout status deployment/api-gateway -n shopping-app
```

## Troubleshooting

### Common Issues and Solutions

#### 1. Pods not starting
```bash
# Check pod logs
kubectl logs -l app=api-gateway -n shopping-app

# Check pod events
kubectl describe pod -l app=api-gateway -n shopping-app
```

#### 2. Services not accessible
```bash
# Check service endpoints
kubectl get endpoints -n shopping-app

# Check service configuration
kubectl describe service api-gateway-service -n shopping-app
```

#### 3. Security context issues
```bash
# Check security contexts
kubectl get pod -l app=api-gateway -n shopping-app -o yaml | grep -A 10 securityContext
```

#### 4. Network policy issues
```bash
# Check network policies
kubectl get networkpolicy -n shopping-app
kubectl describe networkpolicy -n shopping-app
```

### Cleanup Commands

```bash
# Remove microservices
kubectl delete -f k8s/

# Remove infrastructure
cd infra/terraform
terraform destroy

# Remove namespace
kubectl delete namespace shopping-app
```

## Success Criteria

✅ **Security Scanning**: All security scans pass without high-severity issues
✅ **Infrastructure**: Terraform successfully creates all resources
✅ **Microservices**: All pods are running and healthy
✅ **Security**: Containers run as non-root with proper security contexts
✅ **CI/CD**: Pipeline successfully builds and deploys on code changes
✅ **Network**: Services are accessible and network policies are enforced

## Next Steps After Testing

1. **Production Setup**: Configure production Kubernetes cluster
2. **Monitoring**: Set up Prometheus and Grafana
3. **Logging**: Configure ELK stack for centralized logging
4. **Backup**: Set up backup strategies for persistent data
5. **Scaling**: Configure horizontal pod autoscaling
