resource "azurerm_resource_group" "prod_rg" {
    name = "${var.environment.name}-rg"
    location = var.environment.location
}

module "prod_networking" {
  source      = "../modules/networking"
  environment = local.environments.prod

  depends_on = [azurerm_resource_group.prod_rg]
}

module "prod_identity" {
  source      = "../modules/identity"
  environment = local.environments.prod

  depends_on = [azurerm_resource_group.prod_rg]
}

module "prod_security" {
  source      = "../modules/security"
  environment = local.environments.prod
  subnet_id   = module.prod_networking.subnet_id

  depends_on = [module.prod_networking]
}

module "prod_aks" {
  source                     = "../modules/aks"
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
  source             = "../modules/keyvault"
  environment        = local.environments.prod
  sku_name_key_vault = var.sku_name_key_vault

  # Node.js / Backend Variables
  backend_NODE_ENV             = var.NODE_ENV
  backend_PORT                 = var.PORT
  backend_SECRET               = var.SECRET
  backend_KEY                  = var.KEY
  backend_JWT_SCHEME           = var.JWT_SCHEME
  backend_JWT_TOKEN_PREFIX     = var.JWT_TOKEN_PREFIX
  backend_JWT_SECRET           = var.JWT_SECRET
  backend_JWT_TOKEN_EXPIRATION = var.JWT_TOKEN_EXPIRATION
  backend_JWT_TOKEN_HASH_ALGO  = var.JWT_TOKEN_HASH_ALGO

  # MongoDB Variables
  mongo_DATABASE = var.DATABASE
  mongo_MONGO_DB = var.MONGO_DB

  depends_on = [azurerm_resource_group.prod_rg]
}

module "prod_iam" {
  source                    = "../modules/iam"
  environment               = local.environments.prod
  vault_key_id              = module.prod_keyvault.vault_id_output
  acr_id                    = module.prod_acr.acr_id
  user_assigned_identity_id = module.prod_identity.principal_id

  depends_on = [module.prod_aks, module.prod_keyvault, module.prod_acr]
}

module "prod_acr" {
  source                           = "../modules/acr"
  acr_sku                          = var.acr_sku
  environment                      = local.environments.prod
  key_vault_key_id                 = module.prod_keyvault.key_vault_key_id
  user_assigned_identity_id        = module.prod_identity.id
  user_assigned_identity_client_id = module.prod_identity.client_id
  principal_id                     = module.prod_identity.principal_id
  vault_id_output                  = module.prod_keyvault.vault_id_output

  depends_on = [azurerm_resource_group.prod_rg, module.prod_keyvault]
}