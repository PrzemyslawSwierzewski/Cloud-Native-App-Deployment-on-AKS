resource "azurerm_container_registry" "stage_acr" {
  name                = "${var.environment.name}container"
  resource_group_name = var.environment.rg_name
  location            = var.environment.location
  sku                 = var.acr_sku
  zone_redundancy_enabled = true

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  dynamic "encryption" {
    for_each = var.key_vault_key_id != null ? [1] : []
    content {
      key_vault_key_id   = var.key_vault_key_id
      identity_client_id = var.user_assigned_identity_client_id
    }
  }

  depends_on = [azurerm_role_assignment.acr_keyvault_access]
}


resource "azurerm_role_assignment" "acr_keyvault_access" {
  scope                = var.vault_id_output
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = var.principal_id
}
