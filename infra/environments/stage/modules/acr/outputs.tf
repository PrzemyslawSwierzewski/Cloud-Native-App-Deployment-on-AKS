output "acr_id" {
  value = azurerm_container_registry.stage_acr.id
}

output "acr_identity_principal_id" {
  value = azurerm_container_registry.stage_acr.identity[0].principal_id
}

output "acr_name" {
  value = azurerm_container_registry.stage_acr.name
}