data "azurerm_key_vault" "datakeyvault" {
  name                = local.name_of_key_vault_data
  resource_group_name = var.environment.rg_name

  depends_on = [azurerm_key_vault.devkeyvault]
}