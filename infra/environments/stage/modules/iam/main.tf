resource "azurerm_user_assigned_identity" "stage_usi" {
  location            = var.environment.location
  name                = "${var.environment.name}_user_assigned_identity"
  resource_group_name = var.environment.rg_name
}

resource "azurerm_role_assignment" "aks_keyvault_secrets" {
  scope                = var.key_vault_key_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.kubernetes_cluster_id_principal_id
}