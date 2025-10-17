# 🚀 DevSecOps Setup Guide

## Prerequisites

Install:
- Docker Desktop
- Kubernetes (Docker Desktop, kind, or minikube)
- kubectl
- Helm
- Terraform (>= 1.0)

Verify:
```bash
docker --version
kubectl version --client
helm version
terraform --version
```

## Configure Kubernetes

- Enable Kubernetes in Docker Desktop, or create a kind/minikube cluster
- Verify:
```bash
kubectl cluster-info
kubectl get nodes
```

## Configure GitHub Secrets

Repository → Settings → Secrets and variables → Actions
- REGISTRY_USERNAME
- REGISTRY_PASSWORD
- KUBECONFIG_DATA (base64 of `kubectl config view --raw`)

## Run

- Push code to trigger GitHub Actions
- For local apply:
```bash
kubectl apply -f k8s/
```


