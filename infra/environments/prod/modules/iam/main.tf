data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "aks_keyvault_secrets" {
  scope                = var.vault_key_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.user_assigned_identity_id
}

resource "azurerm_role_assignment" "tf_keyvault_secrets_access" {
  scope                = var.vault_key_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}

resource "azurerm_key_vault_access_policy" "aks_secret_access" {
  key_vault_id = var.vault_key_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.user_assigned_identity_id

  secret_permissions = [
    "get",
    "list"
  ]
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.user_assigned_identity_id
}

