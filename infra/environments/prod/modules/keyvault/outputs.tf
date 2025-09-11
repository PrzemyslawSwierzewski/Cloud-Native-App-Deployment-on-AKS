output "vault_id_output" {
  value = azurerm_key_vault.prodkeyvault.id
}

output "key_vault_name" {
  value = azurerm_key_vault.prodkeyvault.name
}

output "azurerm_key_vault_key_name" {
  value =azurerm_key_vault_key.prod_key.name
}

output "key_vault_key_id" {
  value = azurerm_key_vault_key.prod_key.id
}