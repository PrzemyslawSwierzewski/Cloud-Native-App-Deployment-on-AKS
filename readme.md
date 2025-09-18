#<img width="2195" height="1199" alt="diagram-export-9-18-2025-11_08_07-AM" src="https://github.com/user-attachments/assets/2bdbaaee-e70a-4a72-bc81-bb135bcf35cb" />
 🌐 Cloud-Native Full-Stack Application on Azure AKS

This project demonstrates a **production-grade cloud-native setup** running on **Azure Kubernetes Service (AKS)**. It covers the full lifecycle from infrastructure provisioning to application deployment, using **Terraform, Helm, GitHub Actions CI/CD, and Azure-native services**.

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
  - **Application pipeline** → build, push, scan, and deploy with Helm.  
- **Secrets management** with Azure Key Vault + Managed Identity.  
- **Security** with RBAC, Key Vault role assignments, and ACR access controls.  
- **Scalability & Resilience** with AKS autoscaling, HPA (planned).  
- **Observability** with Prometheus, Grafana, and Azure Monitor (planned).

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
    infra/environments        # Infrastructure code (modular setup)
    ├── dev/
    ├── staging/
    └── prod/
    .github/workflows/        # CI/CD pipelines
    ├── build-deploy.yaml     # App pipeline (Docker + Helm)
    └── terraform.yaml        # Infra pipeline

---

## ⚙️ CI/CD Pipelines

### 🔹 Application Pipeline (`build-deploy.yaml`)
- Triggered on commits to `dev`, `staging`, or `main`.  
- Builds and pushes frontend/backend images to ACR (tagged with commit SHA).  
- Bakes Helm charts with environment-specific overrides.  
- Deploys workloads to AKS.

### 🔹 Infrastructure Pipeline (`terraform.yaml`)
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
5. Build & push Docker images:
```bash
       Best option to build the images is to run the workflow
```
6. Deploy with Helm:
```bash
       Best option to deploy the application is to run the workflow
```
---

## 🔐 Secrets Management

- Secrets (MongoDB, app configs) stored in will be stored in **Azure Key Vault**.  
- AKS workloads access secrets via **Managed Identity + RBAC**.

---

## 📊 Roadmap

- [x] Modular multi-environment Terraform setup  
- [x] Helm charts for app workloads  
- [x] CI/CD pipelines for infra and app  
- [ ] Implement RBAC, NetworkPolicies, PodSecurity  
- [ ] Add monitoring with Prometheus + Grafana + Azure Monitor  
- [ ] Configure Horizontal Pod Autoscaler (HPA)
- [ ] Move kubernetes secrets from manifest files to **Azure Key Vault**

---
