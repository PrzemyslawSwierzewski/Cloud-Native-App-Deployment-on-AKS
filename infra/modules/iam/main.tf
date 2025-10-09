data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "aks-keyvault-secrets" {
  scope                = var.vault_key_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.user_assigned_identity_id
}

resource "azurerm_role_assignment" "tf-keyvault-secrets-access" {
  scope                = var.vault_key_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}

resource "azurerm_key_vault_access_policy" "aks-secret-access" {
  key_vault_id = var.vault_key_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.user_assigned_identity_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_role_assignment" "aks-acr-pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.user_assigned_identity_id
}

