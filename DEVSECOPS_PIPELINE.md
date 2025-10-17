# 🛡️ DevSecOps Pipeline for Shopping Website Microservices

This document outlines the comprehensive DevSecOps pipeline implemented for the Node.js microservice-based shopping website.

## Phases

1. Security Scanning (CI): CodeQL, npm audit, Trivy
2. CI/CD Deployment: Docker build/push, Kubernetes apply, rollout checks
3. Runtime Security: Non-root, read-only FS, probes, limits, network policies
4. Infrastructure as Code: Terraform for namespace, RBAC, RabbitMQ, Ingress

## GitHub Actions

Workflow: `.github/workflows/devsecops.yaml`
- CodeQL for JavaScript
- npm audit with `--audit-level=high`
- Trivy container scans (SARIF uploaded)
- Build and push images to GHCR (tagged with commit SHA)
- Apply k8s manifests and verify rollout

## Kubernetes

Manifests in `k8s/` include:
- Namespace `shopping-app`
- Deployments and Services for all microservices
- RabbitMQ Deployment + Service
- Ingress for `shopping-app.local`
- NetworkPolicy to restrict traffic
- Secrets placeholder

Security:
- `runAsNonRoot: true`, `readOnlyRootFilesystem: true`
- Drop all capabilities
- Liveness/Readiness probes
- Resource requests/limits

## Terraform

Folder: `infra/terraform/`
- `main.tf` providers: docker, kubernetes, helm
- Namespace, ConfigMap, Secret, ServiceAccount, Role/Binding
- Helm: RabbitMQ and Ingress-NGINX
- NetworkPolicy
- `variables.tf`, `outputs.tf`, `terraform.tfvars.example`

Benefits:
- Reproducibility, versioning, auditability, consistency

## GitHub Secrets

- `REGISTRY_USERNAME`
- `REGISTRY_PASSWORD`
- `KUBECONFIG_DATA` (base64 kubeconfig)

## Usage

- Push to main to run workflow
- `kubectl apply -f k8s/` for local
- `infra/terraform/` for IaC demo


