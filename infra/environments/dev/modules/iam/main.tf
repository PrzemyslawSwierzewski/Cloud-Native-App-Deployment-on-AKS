resource "azurerm_user_assigned_identity" "dev-usi" {
  location            = var.location
  name                = "${var.environment}-user-assigned-identity"
  resource_group_name = var.rg_name
}
