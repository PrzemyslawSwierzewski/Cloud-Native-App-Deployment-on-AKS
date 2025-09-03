data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "stagekeyvault" {
  name                        = "${var.environment.name}-key"
  location                    = var.environment.location
  resource_group_name         = var.environment.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7 # Note: In prod, I will increase this to 90days
  purge_protection_enabled    = false # Note: In prod, I will enable this to true
  rbac_authorization_enabled = true

  # Note: In production, I will enforce private_endpoint
  # In dev/stage, I will keep it public for cost and simplicity.

  sku_name = var.sku_name_key_vault
  
  tags = {
    Environment = var.environment.name
  }
}

