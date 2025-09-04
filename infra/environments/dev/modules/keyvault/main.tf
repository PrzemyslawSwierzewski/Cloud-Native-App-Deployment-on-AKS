data "azurerm_client_config" "current" {}

resource "random_string" "kv_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_key_vault" "devkeyvault" {
  name                        = "kv-${var.environment.name}-${random_string.kv_suffix.result}"
  location                    = var.environment.location
  resource_group_name         = var.environment.rg_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7 # Note: In prod, I will increase this to 90days
  purge_protection_enabled    = false # Note: In prod, I will enable this to true
  rbac_authorization_enabled = true
  sku_name = var.sku_name_key_vault
  
  # Note: In production, I will enforce private_endpoint  # In dev/stage, I will keep it public for cost and simplicity.
  
  tags = {
    Environment = var.environment.name
  }
}