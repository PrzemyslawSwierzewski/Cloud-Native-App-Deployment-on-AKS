resource "azurerm_resource_group" "infra_rgs" {
  for_each = local.environments

  name     = each.value.rg_name
  location = each.value.location
}

# module "dev_networking" {
#   source = "./environments/dev/modules/networking"
#   environment = local.environments.dev
#   nsg_id = module.dev_security.nsg_id

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "dev_security" {
#   source = "./environments/dev/modules/security"
#   environment = local.environments.dev
#   subnet_id = module.dev_networking.subnet_id

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "dev_aks" {
#   source = "./environments/dev/modules/aks"
#   environment = local.environments.dev
#   default_node_pool = var.default_node_pool_dev_stage
#   subnet_id = module.dev_networking.subnet_id

#   depends_on = [module.dev_networking, module.dev_security]
# }

# module "dev_keyvault" {
#   source = "./environments/dev/modules/keyvault"
#   environment = local.environments.dev
#   sku_name_key_vault = var.sku_name_key_vault

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "dev_iam" {
#   source = "./environments/dev/modules/iam"
#   environment = local.environments.dev
#   vault_key_id = module.dev_keyvault.vault_id_output
#   kubernetes_cluster_id_principal_id = module.dev_aks.kubernetes_cluster_id_principal_id
#   user_assigned_identity_id = module.dev_iam.user_assigned_identity_id

#   depends_on = [module.dev_aks, module.dev_keyvault]
# }

# module "dev_acr" {
#   source = "./environments/dev/modules/acr"
#   acr_sku = var.acr_skus
#   environment = local.environments.dev
#   user_assigned_identity_id = module.dev_iam.user_assigned_identity_id
#   vault_key_id = module.dev_keyvault.vault_id_output
#   user_assigned_identity_name = module.dev_iam.user_assigned_identity_name
#   key_vault_name = module.dev_keyvault.key_vault_name

#   depends_on = [module.dev_iam, module.dev_keyvault]
# }

module "prod_networking" {
  source = "./environments/prod/modules/networking"
  environment = local.environments.prod

  depends_on = [azurerm_resource_group.infra_rgs]
}

module "prod_identity" {
  source = "./environments/prod/modules/identity"
  environment = local.environments.prod
}

module "prod_security" {
  source = "./environments/prod/modules/security"
  environment = local.environments.prod
  subnet_id = module.prod_networking.subnet_id

  depends_on = [module.prod_networking]
}

module "prod_aks" {
  source = "./environments/prod/modules/aks"
  environment = local.environments.prod
  default_node_pool = var.default_node_pool_prod
  subnet_id = module.prod_networking.subnet_id
  user_assigned_identity_id = module.prod_identity.id
  prod_aks_scaling_min_count = var.prod_aks_scaling_min_count
  prod_aks_scaling_max_count = var.prod_aks_scaling_max_count

  depends_on = [module.prod_networking, module.prod_security]
}

module "prod_keyvault" {
  source = "./environments/prod/modules/keyvault"
  environment = local.environments.prod
  sku_name_key_vault = var.sku_name_key_vault

  depends_on = [azurerm_resource_group.infra_rgs]
}

module "prod_iam" {
  source = "./environments/prod/modules/iam"
  environment = local.environments.prod
  vault_key_id = module.prod_keyvault.vault_id_output
  acr_id = module.prod_acr.acr_id
  user_assigned_identity_id = module.prod_identity.principal_id

  depends_on = [module.prod_aks, module.prod_keyvault, module.prod_acr]
}

module "prod_acr" {
  source = "./environments/prod/modules/acr"
  acr_sku = var.acr_skus
  environment = local.environments.prod
  key_vault_key_id = module.prod_keyvault.key_vault_key_id
  user_assigned_identity_id = module.prod_identity.id
  user_assigned_identity_client_id = module.prod_identity.client_id
  principal_id = module.prod_identity.principal_id
  vault_id_output = module.prod_keyvault.vault_id_output

  depends_on = [azurerm_resource_group.infra_rgs, module.prod_keyvault]
}



############################################################################################################
# The monitoring module is commented out for now, as I want to implement the monitoring solution as below:
# https://github.com/Azure/prometheus-collector/blob/main/AddonTerraformTemplate/main.tf
############################################################################################################


# module "prod_monitoring" {
#   source = "./environments/prod/modules/monitoring"
#   environment = local.environments.prod
#   vault_key_id = module.prod_keyvault.vault_id_output
#   kubernetes_cluster_id = module.prod_aks.kubernetes_cluster_id
#   acr_id = module.prod_acr.acr_id
#   nsg_id = module.prod_security.nsg_id
#   vnet_id = module.prod_networking.vnet_id
#   owner_email_address = var.owner_email_address
#
#   depends_on = [module.prod_aks, module.prod_acr, module.prod_keyvault, module.prod_networking, module.prod_security]
# }

# module "stage_networking" {
#   source = "./environments/stage/modules/networking"
#   environment = local.environments.stage
#   nsg_id = module.stage_security.nsg_id

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "stage_security" {
#   source = "./environments/stage/modules/security"
#   environment = local.environments.stage
#   subnet_id = module.stage_networking.subnet_id

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "stage_aks" {
#   source = "./environments/stage/modules/aks"
#   environment = local.environments.stage
#   default_node_pool = var.default_node_pool_dev_stage
#   subnet_id = module.stage_networking.subnet_id

#   depends_on = [module.stage_networking, module.stage_security]
# }

# module "stage_keyvault" {
#   source = "./environments/stage/modules/keyvault"
#   environment = local.environments.stage
#   sku_name_key_vault = var.sku_name_key_vault

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "stage_iam" {
#   source = "./environments/stage/modules/iam"
#   environment = local.environments.stage
#   vault_key_id = module.stage_keyvault.vault_id_output
#   kubernetes_cluster_id_principal_id = module.stage_aks.kubernetes_cluster_id_principal_id
#   user_assigned_identity_id = module.stage_iam.user_assigned_identity_id

#   depends_on = [module.stage_aks, module.stage_keyvault]
# }

# module "stage_acr" {
#   source = "./environments/stage/modules/acr"
#   acr_sku = var.acr_skus
#   environment = local.environments.stage
#   user_assigned_identity_id = module.stage_iam.user_assigned_identity_id
#   vault_key_id = module.stage_keyvault.vault_id_output
#   user_assigned_identity_name = module.stage_iam.user_assigned_identity_name
#   key_vault_name = module.stage_keyvault.key_vault_name

#   depends_on = [module.stage_iam, module.stage_keyvault]
# }
