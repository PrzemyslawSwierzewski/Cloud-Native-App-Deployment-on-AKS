data "azurerm_user_assigned_identity" "usi_data" {
  name                = azurerm_user_assigned_identity.dev_usi.name
  resource_group_name = var.environment.rg_name
}