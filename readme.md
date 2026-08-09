<img width="2195" height="1199" alt="diagram-export-9-18-2025-11_08_07-AM" src="https://github.com/user-attachments/assets/2bdbaaee-e70a-4a72-bc81-bb135bcf35cb" />

## Diagram above is focused on the production environment. I’ve left out staging and development to keep it clean :)
---

## 🌐 Cloud-Native Full-Stack Application on Azure AKS**

This project demonstrates a **production-grade cloud-native setup** running on **Azure Kubernetes Service (AKS)**. It covers the full lifecycle from infrastructure provisioning to application deployment, using **Terraform, Helm, GitHub Actions CI/CD, Flux CD GitOps, and Azure-native services**.

---

## 🚀 Features

- **Infrastructure as Code** with Terraform (modular, multi-environment: dev, staging, prod).  
- **Full-stack application(forked from a public repo https://github.com/idurar/mern-admin)**:  
  - React frontend  
  - Node.js/Express backend  
  - MongoDB (StatefulSet with persistent storage)  
  - NGINX reverse proxy + LoadBalancer for external traffic  
- **Containerization** with custom Dockerfiles, images pushed to Azure Container Registry (ACR).  
- **CI/CD Pipelines** with GitHub Actions:  
  - **Infrastructure pipeline** → `terraform fmt`, validate, plan, security scan, and apply.  
  - **Application pipeline** → build & push images to ACR.  
- **GitOps with Flux CD**:  
  - Declarative deployments from Git  
  - Automatic image updates from ACR  
  - Environment-based synchronization (dev, staging, prod)  
- **Secrets management** with Azure Key Vault + Managed Identity.  
- **Security** with RBAC, Key Vault role assignments, and ACR access controls.  
- **Scalability & Resilience** with AKS autoscaling, HPA (planned).  
- This project includes a **dedicated Terraform module** for setting up **Azure-native monitoring** integrated with AKS.

---

## 🏗️ Architecture

- **Azure Resources** (per environment):  
  - Resource Group  
  - Virtual Network + Subnet + NSG  
  - AKS cluster (autoscaling node pools)  
  - ACR with Key Vault–based encryption  
  - Azure Key Vault (secrets, keys)  
  - User-Assigned Managed Identity with role assignments  

- **Application Workloads**:  
  - Frontend, backend, MongoDB, NGINX  
  - Deployed via Helm charts with environment-specific overrides

---

## 📦 Repository Structure

    app/                      # Application source code
    ├── frontend/             # React frontend + Dockerfile
    └── backend/              # Node/Express backend + Dockerfile
    charts/                   # Helm charts for workloads
    ├── fullstack/            # Main chart
    ├── values-dev.yaml
    ├── values-stage.yaml
    └── values-prod.yaml
    flux/                     # Flux CD GitOps configuration
    ├── sources/              # Git & Image repositories
    ├── kustomization/        # Environment-specific deployments
    ├── clusters/             # Bootstrap configs per cluster
    ├── namespaces/           # Kubernetes namespaces
    └── setup-*.sh            # Setup scripts for each environment
    infra/environments        # Infrastructure code (modular setup)
    ├── dev/
    ├── staging/
    └── prod/
    .github/workflows/        # CI/CD pipelines
    ├── Build-deploy.yaml     # App pipeline (Docker build & push)
    └── Terraform-workflow.yaml # Infra pipeline

---

## ⚙️ CI/CD & GitOps Pipelines

### 🔹 Application Pipeline (`Build-deploy.yaml`)
- Triggered on commits to `dev`, `staging`, or `main`.  
- Builds and pushes frontend/backend images to ACR (tagged with commit SHA and latest).  
- Simple, efficient build-only pipeline (no deployment).

### 🔹 GitOps Deployment (Flux CD)
- Monitors Git branches and ACR for image updates.
- **PROD** (main branch) → prodcontainerr ACR → prod-aks-cluster
- **STAGING** (staging branch) → stagingcontainerr ACR → staging-aks-cluster  
- **DEV** (dev branch) → devcontainerr ACR → dev-aks-cluster
- Automatically syncs deployments when images are pushed or Git changes are made.
- [See Flux CD Setup Guide](./docs/FLUX_SETUP.md)

### 🔹 Infrastructure Pipeline (`Terraform-workflow.yaml`)
- Triggered on changes to Terraform code.  
- Runs `fmt`, `validate`, `plan`, security scan, and `apply`.  
- Manages environment-specific resources via modules.

---

## 🚦 Getting Started

### Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads)  
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)  
- [kubectl](https://kubernetes.io/docs/tasks/tools/)  
- [Helm](https://helm.sh/docs/intro/install/)  
- [Docker](https://www.docker.com/get-started)

### Setup
1. Clone the repo:
```bash
       git clone https://github.com/yourusername/cloud-native-aks.git
       cd cloud-native-aks
```
2. Configure these Secrets in GitHub so the automation for changes can work later:
```bash
    ARM_CLIENT_ID
    ARM_CLIENT_SECRET
    ARM_SUBSCRIPTION_ID
    ARM_TENANT_ID
    AZURE_CREDENTIALS
    EMAIL_ADDRESS
    TFSEC_GITHUB_TOKEN
    TF_API_TOKEN
```
3. Authenticate with Azure:
```bash 
       az login
```
4. Provision infrastructure:
```bash
       cd infra
       terraform init
       terraform apply
```
5. Configure these secrets in GitHub to ensure the application functions correctly. They will be passed from the Terraform workflow to Azure Key Vault, and later to Flux.
```bash
    NODE_ENV: "development"
    PORT: "4000"
    SECRET: "hackthoon"
    KEY: "idurar"
    JWT_SCHEME: "jwt"
    JWT_TOKEN_PREFIX: "Bearer"
    JWT_SECRET: "thiscanbechangedlater123654789"
    JWT_TOKEN_EXPIRATION: "18000000"
    JWT_TOKEN_HASH_ALGO: "SHA-256"
    DATABASE: "mongodb://mongo.default.svc.cluster.local:27017/mydb"
    MONGO_DB: "mydb"
```
6. Setup Flux CD on your AKS clusters:
```bash
       export GITHUB_TOKEN=<your-github-token>
       bash flux/setup-prod.sh    # Setup PROD cluster
       bash flux/setup-staging.sh # Setup STAGING cluster
       bash flux/setup-dev.sh     # Setup DEV cluster
```
For detailed setup instructions, see [Flux CD Setup Guide](./docs/FLUX_SETUP.md)

7. Push Docker images:
```bash
       Push commits to dev/staging/main branches to trigger GitHub Actions
       Images are built and pushed to ACR automatically
```
8. Flux automatically deploys:
```bash
       Flux watches ACR and Git, deploying changes automatically to each AKS cluster
       No manual kubectl apply or Helm deploy needed!
```
---

## 🔐 Secrets Management

- Secrets (MongoDB, app configs) stored in will be stored in **Azure Key Vault**.  
- AKS workloads access secrets via **Managed Identity + RBAC**.

## 📡 Monitoring & Observability

This project includes a **dedicated Terraform module** for setting up **Azure-native monitoring** integrated with AKS.

### 🔹 What it Provisions
- **Azure Monitor Workspace (AMW)** → centralized telemetry store.  
- **Data Collection Endpoints (DCEs)** → manage cross-region/private cluster ingestion.  
- **Data Collection Rules (DCRs) + Associations** → route Kubernetes metrics to AMW.  
- **Prometheus Recording Rules**:
  - **Linux Nodes**
  - **Windows Nodes**
  - **Kubernetes Cluster**
  - **User Experience (UX) metrics**  
- **Grafana Integration**:
  - Native Azure integration with AMW
  - Role assignments (`Monitoring Data Reader`) for secure access

### 🔹 Why This Matters
- Provides **end-to-end observability** using **Azure Monitor Managed Prometheus**.  
- Collects, processes, and stores cluster-level metrics without needing to run and maintain your own Prometheus stack.  
- Seamlessly integrates with **Grafana dashboards** for visualization.  

---

## 📊 Roadmap

- [x] Modular multi-environment Terraform setup  
- [x] Helm charts for app workloads  
- [x] CI/CD pipelines for infra and app  
- [x] GitOps with Flux CD for declarative deployments
- [ ] Implement RBAC, NetworkPolicies, PodSecurity  
- [x] Add monitoring with Prometheus + Grafana + Azure Monitor  
- [ ] Configure Horizontal Pod Autoscaler (HPA)
- [x] Move kubernetes secrets from manifest files to **Azure Key Vault**
- [x] Multi-environment Workflow setup (dev, staging, prod)
- [x] Security implementations with tfsec
- [ ] Refactor the infrastructure structure so a single set of modules can be parameterized and shared across all environments, instead of maintaining separate modules per environment

---
