# 🧪 DevSecOps Pipeline Testing Guide

## CI Security Scans

1. Push a commit to main/master
2. Check Actions: CodeQL, npm audit, Trivy
3. Review Security tab in GitHub

## Terraform Infrastructure

```bash
cd infra/terraform
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
terraform apply
```

Verify:
```bash
kubectl get namespaces | grep shopping-app
helm list -A
kubectl get networkpolicy -n shopping-app
```

## Deploy Microservices

```bash
kubectl apply -f k8s/
kubectl get pods -n shopping-app
kubectl get services -n shopping-app
```

Wait for readiness:
```bash
kubectl wait --for=condition=ready pod -l app=api-gateway -n shopping-app --timeout=300s
```

## Access App

```bash
kubectl port-forward service/frontend-service 3005:3000 -n shopping-app &
start http://localhost:3005
```

## Validate Security

- Non-root user: `kubectl exec -it deploy/api-gateway -n shopping-app -- id`
- Resource limits: `kubectl describe pod -l app=api-gateway -n shopping-app | findstr Limits`
- NetworkPolicy: `kubectl get networkpolicy -n shopping-app`


