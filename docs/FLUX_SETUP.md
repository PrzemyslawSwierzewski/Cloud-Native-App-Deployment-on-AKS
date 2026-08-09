# Flux CD Setup Guide

## Overview
This project uses Flux CD for continuous deployment on AKS. The workflow is simple:
1. Push code to GitHub (main, staging, or dev branch)
2. GitHub Actions builds and pushes Docker images to ACR
3. Flux automatically syncs the latest images to AKS clusters

## Quick Start

### Prerequisites
- Flux CLI installed: `curl -s https://fluxcd.io/install.sh | sudo bash`
- GitHub personal access token with repo permissions
- Azure CLI configured with access to your subscriptions

### 1. Setup PROD Cluster
```bash
export GITHUB_TOKEN=<your-github-token>
bash flux/setup-prod.sh
```

### 2. Setup STAGING Cluster
```bash
export GITHUB_TOKEN=<your-github-token>
bash flux/setup-staging.sh
```

### 3. Setup DEV Cluster
```bash
export GITHUB_TOKEN=<your-github-token>
bash flux/setup-dev.sh
```

## Project Structure
```
flux/
├── namespaces/           # Kubernetes namespaces
├── sources/              
│   ├── github.yaml       # Git repositories (main, staging, dev branches)
│   └── image-policy.yaml # ACR image repositories & policies
├── kustomization/        
│   ├── prod.yaml         # PROD deployment config (prodcontainerr ACR)
│   ├── staging.yaml      # STAGING deployment config (stagingcontainerr ACR)
│   └── dev.yaml          # DEV deployment config (devcontainerr ACR)
├── clusters/             # Cluster-specific bootstrap configs
│   ├── main/             # PROD cluster
│   ├── staging/          # STAGING cluster
│   └── dev/              # DEV cluster
└── setup-*.sh            # Setup scripts for each environment
```

## Environment Configuration

### PROD (main branch)
- **ACR**: prodcontainerr.azurecr.io
- **Git Branch**: main
- **Cluster**: prod-aks-cluster (prod-rg)
- **Images**: frontend:latest, backend:latest

### STAGING (staging branch)
- **ACR**: stagingcontainerr.azurecr.io
- **Git Branch**: staging
- **Cluster**: staging-aks-cluster (staging-rg)
- **Images**: frontend:latest, backend:latest

### DEV (dev branch)
- **ACR**: devcontainerr.azurecr.io
- **Git Branch**: dev
- **Cluster**: dev-aks-cluster (dev-rg)
- **Images**: frontend:latest, backend:latest

## Monitoring

### Check Flux status
```bash
flux get all -A
```

### View sync status
```bash
flux get kustomization -A
```

### Check image automation
```bash
flux get images all -A
```

### View logs
```bash
flux logs --all-namespaces --follow
```

### Check specific environment
```bash
# PROD
kubectl get deployment -n default
flux reconcile kustomization app-prod

# STAGING
kubectl get deployment -n default
flux reconcile kustomization app-staging

# DEV
kubectl get deployment -n default
flux reconcile kustomization app-dev
```

## Manual Operations

### Force sync a specific environment
```bash
flux reconcile source git app-repo         # PROD
flux reconcile source git app-repo-staging # STAGING
flux reconcile source git app-repo-dev     # DEV
```

### Suspend/Resume automation
```bash
flux suspend kustomization app-prod
flux resume kustomization app-prod
```

### View deployment logs
```bash
kubectl logs -n flux-system -l app=source-controller -f
kubectl logs -n flux-system -l app=kustomize-controller -f
```

## Troubleshooting

### Check if Flux is ready
```bash
kubectl get pods -n flux-system
kubectl describe pod -n flux-system <pod-name>
```

### View reconciliation errors
```bash
flux get kustomization --status-selector status!=Ready
```

### Debug Git sync issues
```bash
flux get source git -A
flux describe source git app-repo
```

### Debug image automation
```bash
flux get images all -A
flux describe image app-frontend
```

## Benefits
- **Declarative**: All infrastructure as code in Git
- **GitOps**: Single source of truth for each environment
- **Automated**: Changes sync automatically when pushed
- **Auditable**: Full history in Git
- **Simple**: No complex CI/CD orchestration needed
- **Branch-Based**: Separate configurations for prod/staging/dev
