resource "azurerm_container_registry" "dev_acr" {
  name                = "${var.environment.name}container"
  resource_group_name = var.environment.rg_name
  location            = var.environment.location
  sku                 = var.acr_sku

  identity {
    type = "UserAssigned"
    identity_ids = [
      var.user_assigned_identity_id
    ]
  }

  encryption {
    key_vault_key_id   = var.key_vault_key_id
    identity_client_id = var.user_assigned_identity_id
  }
}