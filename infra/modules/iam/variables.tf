variable "environment" {
  type = object({
    name     = string
    rg_name  = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}

variable "vault_key_id" {
  type        = string
  description = "The ID of the Key Vault key"
}

variable "acr_id" {
  type        = string
  description = "Acr id that was pulled from the root module"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "Principal ID of the shared user-assigned managed identity"
}