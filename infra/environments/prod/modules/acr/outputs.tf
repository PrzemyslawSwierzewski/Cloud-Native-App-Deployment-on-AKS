output "acr_id" {
  value = azurerm_container_registry.prod_acr.id
}

output "acr_identity_principal_id" {
  value = azurerm_container_registry.prod_acr.identity[0].principal_id
}