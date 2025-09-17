output "id" {
  value = azurerm_user_assigned_identity.stage_uasi.id
}

output "client_id" {
  value = azurerm_user_assigned_identity.stage_uasi.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.stage_uasi.principal_id
}
