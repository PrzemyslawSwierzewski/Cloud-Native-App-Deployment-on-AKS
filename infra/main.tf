resource "azurerm_resource_group" "infra_rgs" {
  for_each = local.environments

  name     = each.value.rg_name
  location = each.value.location
}

############################## DEV ENVIRONMENT ###############################################
# The dev environment is for development, currently not in use as my subscription is limited to 4 cores last fix
##############################################################################################

# module "dev_networking" {
#   source      = "./environments/dev/modules/networking"
#   environment = local.environments.dev

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "dev_identity" {
#   source      = "./environments/dev/modules/identity"
#   environment = local.environments.dev

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "dev_security" {
#   source      = "./environments/dev/modules/security"
#   environment = local.environments.dev
#   subnet_id   = module.dev_networking.subnet_id

#   depends_on = [module.dev_networking]
# }

# module "dev_aks" {
#   source                     = "./environments/dev/modules/aks"
#   environment                = local.environments.dev
#   default_node_pool          = var.default_node_pools.dev
#   subnet_id                  = module.dev_networking.subnet_id
#   user_assigned_identity_id  = module.dev_identity.id
#   dev_aks_scaling_min_count = var.aks_scaling.stage.min
#   dev_aks_scaling_max_count = var.aks_scaling.stage.max
#   principal_id               = module.dev_identity.principal_id
#   client_id                  = module.dev_identity.client_id

#   depends_on = [module.dev_networking, module.dev_security]
# }

# module "dev_keyvault" {
#   source             = "./environments/dev/modules/keyvault"
#   environment        = local.environments.dev
#   sku_name_key_vault = var.sku_name_key_vault

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "dev_iam" {
#   source                    = "./environments/dev/modules/iam"
#   environment               = local.environments.dev
#   vault_key_id              = module.dev_keyvault.vault_id_output
#   acr_id                    = module.dev_acr.acr_id
#   user_assigned_identity_id = module.dev_identity.principal_id

#   depends_on = [module.dev_aks, module.dev_keyvault, module.dev_acr]
# }

# module "dev_acr" {
#   source                           = "./environments/dev/modules/acr"
#   acr_sku                          = var.acr_sku
#   environment                      = local.environments.dev
#   key_vault_key_id                 = module.dev_keyvault.key_vault_key_id
#   user_assigned_identity_id        = module.dev_identity.id
#   user_assigned_identity_client_id = module.dev_identity.client_id
#   principal_id                     = module.dev_identity.principal_id
#   vault_id_output                  = module.dev_keyvault.vault_id_output

#   depends_on = [azurerm_resource_group.infra_rgs, module.dev_keyvault]
# }

module "prod_networking" {
  source      = "./environments/prod/modules/networking"
  environment = local.environments.prod

  depends_on = [azurerm_resource_group.infra_rgs]
}

module "prod_identity" {
  source      = "./environments/prod/modules/identity"
  environment = local.environments.prod

  depends_on = [azurerm_resource_group.infra_rgs]
}

module "prod_security" {
  source      = "./environments/prod/modules/security"
  environment = local.environments.prod
  subnet_id   = module.prod_networking.subnet_id

  depends_on = [module.prod_networking]
}

module "prod_aks" {
  source                     = "./environments/prod/modules/aks"
  environment                = local.environments.prod
  default_node_pool          = var.default_node_pools.prod
  subnet_id                  = module.prod_networking.subnet_id
  user_assigned_identity_id  = module.prod_identity.id
  prod_aks_scaling_min_count = var.aks_scaling.stage.min
  prod_aks_scaling_max_count = var.aks_scaling.stage.max
  principal_id               = module.prod_identity.principal_id
  client_id                  = module.prod_identity.client_id

  depends_on = [module.prod_networking, module.prod_security]
}

module "prod_keyvault" {
  source             = "./environments/prod/modules/keyvault"
  environment        = local.environments.prod
  sku_name_key_vault = var.sku_name_key_vault

  # Node.js / Backend Variables
  backend_NODE_ENV             = var.NODE_ENV
  backend_PORT                 = var.PORT
  backend_SECRET               = var.SECRET
  backend_KEY                  = var.KEY
  backend_KEY_JWT_SCHEME       = var.KEY_JWT_SCHEME
  backend_JWT_TOKEN_PREFIX     = var.JWT_TOKEN_PREFIX
  backend_JWT_SECRET           = var.JWT_SECRET
  backend_JWT_TOKEN_EXPIRATION = var.JWT_TOKEN_EXPIRATION
  backend_JWT_TOKEN_HASH_ALGO  = var.JWT_TOKEN_HASH_ALGO

  # MongoDB Variables
  mongo_DATABASE  = var.DATABASE
  mongo_MONGO_DB  = var.MONGO_DB

  depends_on = [azurerm_resource_group.infra_rgs]
}

module "prod_iam" {
  source                    = "./environments/prod/modules/iam"
  environment               = local.environments.prod
  vault_key_id              = module.prod_keyvault.vault_id_output
  acr_id                    = module.prod_acr.acr_id
  user_assigned_identity_id = module.prod_identity.principal_id

  depends_on = [module.prod_aks, module.prod_keyvault, module.prod_acr]
}

module "prod_acr" {
  source                           = "./environments/prod/modules/acr"
  acr_sku                          = var.acr_sku
  environment                      = local.environments.prod
  key_vault_key_id                 = module.prod_keyvault.key_vault_key_id
  user_assigned_identity_id        = module.prod_identity.id
  user_assigned_identity_client_id = module.prod_identity.client_id
  principal_id                     = module.prod_identity.principal_id
  vault_id_output                  = module.prod_keyvault.vault_id_output

  depends_on = [azurerm_resource_group.infra_rgs, module.prod_keyvault]
}



############################################################################################################
# The monitoring module is commented out for now, as I want to implement the monitoring solution as below:
# https://github.com/Azure/prometheus-collector/blob/main/AddonTerraformTemplate/main.tf
############################################################################################################


module "prod_monitoring" {
  source       = "./environments/prod/modules/monitoring"
  cluster_name = module.prod_aks.aks_cluster_name
  environment  = local.environments.prod
  cluster_id   = module.prod_aks.kubernetes_cluster_id

  depends_on = [module.prod_aks, module.prod_acr, module.prod_keyvault, module.prod_networking, module.prod_security]
}

# module "stage_networking" {
#   source      = "./environments/stage/modules/networking"
#   environment = local.environments.stage

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "stage_identity" {
#   source      = "./environments/stage/modules/identity"
#   environment = local.environments.stage

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "stage_security" {
#   source      = "./environments/stage/modules/security"
#   environment = local.environments.stage
#   subnet_id   = module.stage_networking.subnet_id

#   depends_on = [module.stage_networking]
# }

# module "stage_aks" {
#   source                     = "./environments/stage/modules/aks"
#   environment                = local.environments.stage
#   default_node_pool          = var.default_node_pools.stage
#   subnet_id                  = module.stage_networking.subnet_id
#   user_assigned_identity_id  = module.stage_identity.id
#   stage_aks_scaling_min_count = var.aks_scaling.stage.min
#   stage_aks_scaling_max_count = var.aks_scaling.stage.max
#   principal_id               = module.stage_identity.principal_id
#   client_id                  = module.stage_identity.client_id

#   depends_on = [module.stage_networking, module.stage_security]
# }

# module "stage_keyvault" {
#   source             = "./environments/stage/modules/keyvault"
#   environment        = local.environments.stage
#   sku_name_key_vault = var.sku_name_key_vault

#   depends_on = [azurerm_resource_group.infra_rgs]
# }

# module "stage_iam" {
#   source                    = "./environments/stage/modules/iam"
#   environment               = local.environments.stage
#   vault_key_id              = module.stage_keyvault.vault_id_output
#   acr_id                    = module.stage_acr.acr_id
#   user_assigned_identity_id = module.stage_identity.principal_id

#   depends_on = [module.stage_aks, module.stage_keyvault, module.stage_acr]
# }

# module "stage_acr" {
#   source                           = "./environments/stage/modules/acr"
#   acr_sku                          = var.acr_sku
#   environment                      = local.environments.stage
#   key_vault_key_id                 = module.stage_keyvault.key_vault_key_id
#   user_assigned_identity_id        = module.stage_identity.id
#   user_assigned_identity_client_id = module.stage_identity.client_id
#   principal_id                     = module.stage_identity.principal_id
#   vault_id_output                  = module.stage_keyvault.vault_id_output

#   depends_on = [azurerm_resource_group.infra_rgs, module.stage_keyvault]
# }
