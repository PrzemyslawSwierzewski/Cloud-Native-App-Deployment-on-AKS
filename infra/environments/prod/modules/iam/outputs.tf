output user_assigned_identity_id {
  value       = azurerm_user_assigned_identity.prod_uasi.id
  description = "Here I'm passing the user assigned identity ID to be used in across prod module"
}

output user_assigned_identity_name {
  value       = azurerm_user_assigned_identity.prod_uasi.name
  description = "Here I'm passing the user assigned identity name to be used in across staging module"
}
