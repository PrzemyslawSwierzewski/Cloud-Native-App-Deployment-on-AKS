output "id" {
  value = azurerm_user_assigned_identity.UAI.id
}

output "client_id" {
  value = azurerm_user_assigned_identity.UAI.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.UAI.principal_id
}
