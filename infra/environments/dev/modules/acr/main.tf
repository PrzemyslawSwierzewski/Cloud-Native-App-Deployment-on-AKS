resource "azurerm_container_registry" "dev-acr" {
  name                = "${local.environment.name}-container"
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = var.acr-sku

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.example.id // user assigned identity to be defined
    ]
  }

  encryption {
    key_vault_key_id   = data.azurerm_key_vault_key.example.id // key vault to be defined
    identity_client_id = azurerm_user_assigned_identity.example.client_id // user assigned identity to be defined
  }

}