output "vault_id_output" {
  value = azurerm_key_vault.devkeyvault.id
}

output "key_vault_name" {
  value = azurerm_key_vault.devkeyvault.name
}

output "azurerm_key_vault_key_name" {
  value =azurerm_key_vault_key.dev_key.name
}

output "key_vault_key_id" {
  value = azurerm_key_vault_key.dev_key.id
}