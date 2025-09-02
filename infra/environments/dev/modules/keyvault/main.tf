data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "devkeyvault" {
  name                        = "${var.environment.name}-key"
  location                    = var.environment.location
  resource_group_name         = var.environment.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  rbac_authorization_enabled = true

  sku_name = var.sku_name_key_vault

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Sign",
      "Verify",
      "WrapKey",
      "UnwrapKey"
    ]

    secret_permissions = [
      "Get",
      "List"
    ]

    storage_permissions = [
      "Get"
    ]
  }
}