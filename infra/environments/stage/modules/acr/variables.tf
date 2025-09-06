variable "environment" {
  type = object({
    name    = string
    rg_name = string
    location = string
  })
  description = "Values for a single environment, including rg_name and location and name of the environment"
}

variable "acr_sku" {
    type = string
    description = "Acr sku that was pulled from the root module"
}

variable "user_assigned_identity_id" {
  type        = string
  description = "The ID of the user-assigned managed identity pulled from the iam module"
}

variable "vault_key_id" {
  type        = string
  description = "The ID of the key vault key pulled from the keyvault module"
}

variable "user_assigned_identity_name" {
  type        = string
  description = "The name of the user-assigned managed identity pulled from the iam module"
}

variable "key_vault_name" {
  type = string
  description = "The name of the key vault"
}

variable "key_vault_key_name" {
  type = string
  description = "The name of the key inside the key vault"
}