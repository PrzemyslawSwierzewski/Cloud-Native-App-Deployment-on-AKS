output user_assigned_identity_id {
  value       = azurerm_user_assigned_identity.dev_usi.id
  description = "Here I'm passing the user assigned identity ID to be used in across dev module"
}
