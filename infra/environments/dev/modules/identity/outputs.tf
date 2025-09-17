output "id" {
  value = azurerm_user_assigned_identity.dev_uasi.id
}

output "client_id" {
  value = azurerm_user_assigned_identity.dev_uasi.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.dev_uasi.principal_id
}
