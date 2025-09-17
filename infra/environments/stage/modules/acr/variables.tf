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

variable "key_vault_key_id" {
  type = string
  description = "The ID of the key inside the Key Vault"
}

variable "user_assigned_identity_id" {
  type = string
  description = "The ID of the user assigned identity"
}

variable "user_assigned_identity_client_id" {
  type = string
  description = "The client ID of the user assigned identity"
}

variable "principal_id" {
  type = string
  description = "The principal ID of the user assigned identity"
}

variable "vault_id_output" {
  type = string
  description = "The ID of the Key Vault"
}