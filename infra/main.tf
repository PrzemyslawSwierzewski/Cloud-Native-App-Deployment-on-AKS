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
    subnet_id = module.dev_networking.subnet_id
}

module "dev_aks" {
    source = "./environments/dev/modules/aks"

    environment = local.environments.dev
    default_node_pool = var.default_node_pool
    subnet_id = module.dev_networking.subnet_id
}

module "dev_networking" {
    source = "./environments/dev/modules/networking"

    environment = local.environments.dev
    securitygroupid = module.dev_security.securitygroupid
}

module "prod_acr" {
    source = "./environments/prod/modules/acr"

    acr_sku = var.acr_skus
    environment = local.environments.prod
    user_assigned_identity_id = module.prod_iam.user_assigned_identity_id
    key_vault_key_id = module.prod_keyvault.vault_id_output
}

module "prod_iam" {
    source = "./environments/prod/modules/iam"

    environment = local.environments.prod
    key_vault_key_id = module.prod_keyvault.vault_id_output
    kubernetes_cluster_id_principal_id = module.prod_aks.kubernetes_cluster_id_principal_id
    user_assigned_identity_id = module.prod_iam.user_assigned_identity_id
}

module "prod_keyvault" {
    source = "./environments/prod/modules/keyvault"

    environment = local.environments.prod
    sku_name_key_vault = var.sku_name_key_vault
}

module "prod_security" {
    source = "./environments/prod/modules/security"

    environment = local.environments.prod
    subnet_id = module.dev_networking.subnet_id
}

module "prod_aks" {
    source = "./environments/prod/modules/aks"

    environment = local.environments.prod
    default_node_pool = var.default_node_pool
    subnet_id = module.prod_networking.subnet_id
}

module "prod_networking" {
    source = "./environments/prod/modules/networking"

    environment = local.environments.prod
    securitygroupid = module.dev_security.securitygroupid
}

module "stage_acr" {
    source = "./environments/stage/modules/acr"

    acr_sku = var.acr_skus
    environment = local.environments.stage
    user_assigned_identity_id = module.stage_iam.user_assigned_identity_id
    key_vault_key_id = module.stage_keyvault.vault_id_output
}

module "stage_iam" {
    source = "./environments/stage/modules/iam"

    environment = local.environments.dev
    key_vault_key_id = module.stage_keyvault.vault_id_output
    kubernetes_cluster_id_principal_id = module.stage_aks.kubernetes_cluster_id_principal_id
    user_assigned_identity_id = module.stage_iam.user_assigned_identity_id
}

module "stage_keyvault" {
    source = "./environments/stage/modules/keyvault"

    environment = local.environments.stage
    sku_name_key_vault = var.sku_name_key_vault
}

module "stage_security" {
    source = "./environments/stage/modules/security"

    environment = local.environments.stage
    subnet_id = module.stage_networking.subnet_id
}

module "stage_aks" {
    source = "./environments/stage/modules/aks"

    environment = local.environments.stage
    default_node_pool = var.default_node_pool
    subnet_id = module.stage_networking.subnet_id
}

module "stage_networking" {
    source = "./environments/stage/modules/networking"

    environment = local.environments.stage
    securitygroupid = module.stage_security.securitygroupid
}