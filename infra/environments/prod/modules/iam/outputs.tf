output user_assigned_identity_id {
  value       = azurerm_user_assigned_identity.prod_usi.id
  description = "Here I'm passing the user assigned identity ID to be used in across prod module"
}
