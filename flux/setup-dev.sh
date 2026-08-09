#!/bin/bash
set -e

# Setup Flux CD on DEV AKS Cluster
echo "Setting up Flux CD on DEV cluster..."

export GITHUB_TOKEN="${GITHUB_TOKEN:-}"
export GITHUB_USER="PrzemyslawSwierzewski"
export GITHUB_REPO="Cloud-Native-App-Deployment-on-AKS"
export CLUSTER_NAME="dev-aks-cluster"
export RESOURCE_GROUP="dev-rg"

if [ -z "$GITHUB_TOKEN" ]; then
  echo "Error: GITHUB_TOKEN is not set"
  exit 1
fi

# Login to Azure
echo "Logging in to Azure..."
az login

# Get kubeconfig for DEV cluster
echo "Getting kubeconfig for DEV cluster..."
az aks get-credentials --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP

# Bootstrap Flux
echo "Bootstrapping Flux..."
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repo=$GITHUB_REPO \
  --path=flux/clusters/dev \
  --branch=dev \
  --personal \
  --token-auth \
  --read-write-key

# Wait for Flux to be ready
echo "Waiting for Flux to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/part-of=flux-system -n flux-system --timeout=5m

# Create ACR credentials secret
echo "Creating ACR credentials secret..."
kubectl create secret docker-registry dev-acr-credentials \
  --docker-server=devcontainerr.azurecr.io \
  --docker-username=$(az acr credential show --name devcontainerr --query username -o tsv) \
  --docker-password=$(az acr credential show --name devcontainerr --query passwords[0].value -o tsv) \
  -n flux-system \
  --dry-run=client -o yaml | kubectl apply -f -

# Create GitHub credentials secret
echo "Creating GitHub credentials secret..."
kubectl create secret generic github-credentials \
  --from-literal=username=$GITHUB_USER \
  --from-literal=password=$GITHUB_TOKEN \
  -n flux-system \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Flux CD setup complete for DEV!"
flux get all -n flux-system
