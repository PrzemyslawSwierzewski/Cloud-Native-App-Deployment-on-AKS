output "vault_id_output" {
  value = azurerm_key_vault.devkeyvault.id
}

output "key_vault_name" {
  value = azurerm_key_vault.devkeyvault.name
}