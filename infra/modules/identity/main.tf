resource "azurerm_user_assigned_identity" "UAI" {
  location            = var.environment.location
  name                = "${var.environment.name}_user_assigned_identity"
  resource_group_name = var.environment.rg_name
}