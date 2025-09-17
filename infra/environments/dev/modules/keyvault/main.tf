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
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  rbac_authorization_enabled  = true

  sku_name = var.sku_name_key_vault
  
  tags = {
    Environment = var.environment.name
  }
}

resource "azurerm_key_vault_key" "dev_key" {
  name         = "dev-acr-key"
  key_vault_id = azurerm_key_vault.devkeyvault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt", "wrapKey", "unwrapKey"]
}