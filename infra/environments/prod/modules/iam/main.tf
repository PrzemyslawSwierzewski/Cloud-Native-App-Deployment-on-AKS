resource "azurerm_user_assigned_identity" "prod_uasi" {
  location            = var.environment.location
  name                = "${var.environment.name}_user_assigned_identity"
  resource_group_name = var.environment.rg_name
}

resource "azurerm_role_assignment" "aks_keyvault_secrets" {
  scope                = var.vault_key_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.kubernetes_cluster_id_principal_id
}