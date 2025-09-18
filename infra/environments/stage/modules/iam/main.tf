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

resource "azurerm_role_assignment" "tf_keyvault_keys_access" {
  scope                = var.vault_key_id
  role_definition_name = "Key Vault Crypto User"
  principal_id         = data.azurerm_client_config.current.object_id

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}

resource "azurerm_role_assignment" "aks_node_keyvault_access" {
  scope                = var.vault_key_id
  role_definition_name = "Key Vault Reader"
  principal_id         = var.user_assigned_identity_id
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = var.user_assigned_identity_id
}

resource "azurerm_role_assignment" "tf_acr_push" {
  scope                = var.acr_id
  role_definition_name = "AcrPush"
  principal_id         = data.azurerm_client_config.current.object_id

  lifecycle {
    ignore_changes = [
      principal_id,
    ]
  }
}
