# Fetch the Key Vault key
data "azurerm_key_vault_key" "dev_key" {
  name         = var.vault_key_id                # Name of the key inside Key Vault
  key_vault_id = var.vault_key_id           # ID of the Key Vault itself
}

# Fetch the user-assigned identity
data "azurerm_user_assigned_identity" "dev_identity" {
  name                = "${var.environment.name}user-assigned-identity"
  resource_group_name = var.environment.rg_name
}

resource "azurerm_container_registry" "dev_acr" {
  name                = "${var.environment.name}container"
  resource_group_name = var.environment.rg_name
  location            = var.environment.location
  sku                 = var.acr_sku

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.dev_identity.id]
  }

  encryption {
    key_vault_key_id   = data.azurerm_key_vault_key.dev_key.id
    identity_client_id = data.azurerm_user_assigned_identity.dev_identity.client_id
  }
}
