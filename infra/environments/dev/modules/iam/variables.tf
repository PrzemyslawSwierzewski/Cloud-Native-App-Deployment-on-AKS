variable "environment" {
  type = object({
    name    = string
    rg_name = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}

variable "vault_key_id" {
  type        = string
  description = "The ID of the Key Vault key"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "The ID of the user-assigned managed identity"
}

variable "kubernetes_cluster_id_principal_id" {
  type        = string
  description = "The principal ID of the Kubernetes cluster"
}