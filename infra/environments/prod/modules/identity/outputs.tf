output "id" {
  value = azurerm_user_assigned_identity.prod_uasi.id
}

output "client_id" {
  value = azurerm_user_assigned_identity.prod_uasi.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.prod_uasi.principal_id
}
