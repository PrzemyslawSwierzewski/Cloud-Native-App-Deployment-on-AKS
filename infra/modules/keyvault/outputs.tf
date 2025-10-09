output "vault_id_output" {
  value = azurerm_key_vault.cloud-native-key-vault.id
}

output "key_vault_name" {
  value = azurerm_key_vault.cloud-native-key-vault.name
}

output "azurerm_key_vault_key_name" {
  value = azurerm_key_vault_key.prod-key.name
}

output "key_vault_key_id" {
  value = azurerm_key_vault_key.prod-key.id
}