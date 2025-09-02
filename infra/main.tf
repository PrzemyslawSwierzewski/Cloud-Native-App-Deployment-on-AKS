resource "azurerm_resource_group" "infra_rgs" {
  for_each = local.environments

  name     = each.value.rg_name
  location = each.value.location
}

module "dev_acr" {
    source = "./environments/dev/modules/acr"

    acr_sku = var.acr_skus
    environment = local.environments.dev
    user_assigned_identity_id = module.dev_iam.user_assigned_identity_id
    key_vault_key_id = module.dev_keyvault.vault_id_output
}

module "dev_iam" {
    source = "./environments/dev/modules/iam"

    environment = local.environments.dev
    key_vault_key_id = module.dev_keyvault.vault_id_output
    kubernetes_cluster_id_principal_id = module.dev_aks.kubernetes_cluster_id_principal_id
    user_assigned_identity_id = module.dev_iam.user_assigned_identity_id
}

module "dev_keyvault" {
    source = "./environments/dev/modules/keyvault"

    environment = local.environments.dev
    sku_name_key_vault = var.sku_name_key_vault
}

module "dev_security" {
    source = "./environments/dev/modules/security"

    environment = local.environments.dev
}

module "dev_aks" {
    source = "./environments/dev/modules/aks"

    environment = local.environments.dev
    default_node_pool = var.default_node_pool
}