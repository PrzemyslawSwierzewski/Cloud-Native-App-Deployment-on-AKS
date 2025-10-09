data "azurerm_client_config" "current" {}

resource "random_string" "kv_suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_key_vault" "cloud-native-key-vault" {
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

resource "azurerm_key_vault_key" "prod-key" {
  name         = "${var.environment.name}-acr-key"
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["encrypt", "decrypt", "wrapKey", "unwrapKey"]
}

resource "azurerm_key_vault_secret" "backend_NODE_ENV" {
  name         = "NODE-ENV"
  value        = var.backend_NODE_ENV
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_PORT" {
  name         = "PORT"
  value        = var.backend_PORT
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_SECRET" {
  name         = "SECRET"
  value        = var.backend_SECRET
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_KEY" {
  name         = "KEY"
  value        = var.backend_KEY
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_JWT_SCHEME" {
  name         = "JWT-SCHEME"
  value        = var.backend_JWT_SCHEME
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_JWT_TOKEN_PREFIX" {
  name         = "JWT-TOKEN-PREFIX"
  value        = var.backend_JWT_TOKEN_PREFIX
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_JWT_SECRET" {
  name         = "JWT-SECRET"
  value        = var.backend_JWT_SECRET
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_JWT_TOKEN_EXPIRATION" {
  name         = "JWT-TOKEN-EXPIRATION"
  value        = var.backend_JWT_TOKEN_EXPIRATION
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "backend_JWT_TOKEN_HASH_ALGO" {
  name         = "JWT-TOKEN-HASH-ALGO"
  value        = var.backend_JWT_TOKEN_HASH_ALGO
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "mongo_DATABASE" {
  name         = "DATABASE"
  value        = var.mongo_DATABASE
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}

resource "azurerm_key_vault_secret" "mongo_MONGO_DB" {
  name         = "MONGO-DB"
  value        = var.mongo_MONGO_DB
  key_vault_id = azurerm_key_vault.cloud-native-key-vault.id
}