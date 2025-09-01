# Cloud-Native App Deployment on AKS

## 1) High-level architecture

- **Terraform (modular)** — owns cloud infra only:  
  Resource groups, VNet/subnets, AKS cluster + node pools, ACR, Key Vault, managed identities, LoadBalancer/Ingress (NGINX via Helm release), storage accounts, monitoring resources.

- **Helm charts repo** — owns app manifests (frontend, backend, DB). Charts versioned and stored in Git.

- **CI/CD pipeline (GitHub Actions)** — builds container images, runs tests, pushes to ACR, and deploys updated images via Helm directly to AKS.

- **Secrets** — managed in Azure Key Vault; referenced by Helm values or Kubernetes secrets.

- **Monitoring / Logging / Security** — Prometheus/Grafana, Fluent Bit → Log Analytics, PodSecurity, NetworkPolicy, HPA.

---

## 2) Repo & branching layout

```
infra/ → Terraform modules + environments
  modules/network/
  modules/aks/
  modules/acr/
  modules/keyvault/
  environments/dev/
  environments/stage/
  environments/prod/

charts/ → Helm charts for frontend/backend/DB
  charts/fullstack/

app/ → app source code (frontend + backend)
  frontend/ → Dockerfile
  backend/ → Dockerfile

.github/workflows/ → GitHub Actions to build/push/deploy
```

---

## 3) Terraform modular layout

- **AKS module** → cluster, node pools, managed identity, role assignment to ACR (AcrPull), optional ingress controller via `helm_release`.
- **ACR module** → container registry.
- **Key Vault module** → secrets for DB credentials, API keys, TLS certs.
- **Network module** → VNets, subnets, NSGs.

Infra is fully versioned, environment-specific, and managed via Terraform workspaces or directories.

---

## 4) ACR & image pull

- AKS cluster identity is granted `AcrPull` role in Terraform.
- No `imagePullSecrets` needed; cluster can pull images from ACR automatically.

---

## 5) Helm charts & values

- Single chart `fullstack/` with templates for frontend, backend, DB.
- **Values files example:**

## 6) CI/CD workflow

**Phase 1 — Build & Push Images (CI)**  
Triggered on code push to app repo:

```
Code Push → GitHub Actions →
├─ Checkout Repo
├─ Build frontend Docker image
├─ Build backend Docker image
├─ Tag images with SHA
└─ Push images to ACR
```

**Phase 2 — Deploy Terraform (CD)**

```
├─ Security Scan (tfsec)
├─ Terraform
│  ├─ Terraform Init
│  ├─ Terraform Format
│  ├─ Terraform Plan
│  └─ Terraform Apply (HCP Terraform for remote state)
└─ Deployment complete (atomic/rollback enabled)
```

**Phase 3 — Deploy to AKS via Helm (CD)**  
Triggered after Phase 1 & 2 succeed:

```
CI Success → GitHub Actions →
├─ Checkout Charts Repo
├─ Azure Login & AKS creds
├─ Helm upgrade --install
│  ├─ Pass image tags as overrides
│  └─ Use environment-specific values.yaml
└─ Deployment complete (atomic/rollback enabled)
```

---

## 7) Promotion / environments

- **Dev** → CI deploys automatically to `dev` namespace.  
- **Stage / Prod** → manual approval or CI triggers on `stage`/`prod` branches.  
- Each environment has separate Helm values (`values-dev.yaml`, `values-stage.yaml`, `values-prod.yaml`).

---

## 8) Secrets & configuration

- Secrets stored in Key Vault.  
- Helm values reference secrets via CSI driver (mounted as volumes or environment variables).  
- Avoid storing secrets in repo.

---

## 9) Observability & reliability

- Liveness/readiness probes for all apps.  
- HPA for frontend/backend.  
- Logging/monitoring via Azure Monitor + Prometheus
- NetworkPolicies to secure communication.  
- PodSecurity admission policies enforced.

---

## 10) Optional enhancements

- Canary or blue-green deployments via Helm flags or rollout annotations.  
- Automatic rollback using `helm rollback` if deployment fails.  
- Image scanning and vulnerability check in CI before push.  
- Optional SBOM generation.

---
