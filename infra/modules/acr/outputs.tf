output "acr_id" {
  value = azurerm_container_registry.cloud-native-acr.id
}

output "acr_identity_principal_id" {
  value = azurerm_container_registry.cloud-native-acr.identity[0].principal_id
}

output "acr_name" {
  value = azurerm_container_registry.cloud-native-acr.name
}