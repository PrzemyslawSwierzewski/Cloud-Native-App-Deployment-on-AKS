resource "azurerm_resource_group" "stage-cloud-native-rg" {
  name     = "${local.environments.stage.name}-rg"
  location = local.environments.stage.location
}

module "stage-networking" {
  source      = "../../modules/networking"
  environment = local.environments.stage

  depends_on = [azurerm_resource_group.stage-cloud-native-rg]
}

module "stage-identity" {
  source      = "../../modules/identity"
  environment = local.environments.stage

  depends_on = [azurerm_resource_group.stage-cloud-native-rg]
}

module "stage-security" {
  source      = "../../modules/security"
  environment = local.environments.stage
  subnet_id   = module.stage-networking.subnet_id

  depends_on = [module.stage-networking]
}

module "stage-aks" {
  source                    = "../../modules/aks"
  environment               = local.environments.stage
  default_node_pool         = var.default_node_pools.stage
  subnet_id                 = module.stage-networking.subnet_id
  user_assigned_identity_id = module.stage-identity.id
  aks_scaling_min_count     = var.aks_scaling.stage.min
  aks_scaling_max_count     = var.aks_scaling.stage.max
  principal_id              = module.stage-identity.principal_id
  client_id                 = module.stage-identity.client_id

  depends_on = [module.stage-networking, module.stage-security]
}

module "stage-keyvault" {
  source             = "../../modules/keyvault"
  environment        = local.environments.stage
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

  depends_on = [azurerm_resource_group.stage-cloud-native-rg]
}

module "stage-iam" {
  source                    = "../../modules/iam"
  environment               = local.environments.stage
  vault_key_id              = module.stage-keyvault.vault_id_output
  acr_id                    = module.stage-acr.acr_id
  user_assigned_identity_id = module.stage-identity.principal_id

  depends_on = [module.stage-aks, module.stage-keyvault, module.stage-acr]
}

module "stage-acr" {
  source                           = "../../modules/acr"
  acr_sku                          = var.acr_sku
  environment                      = local.environments.stage
  key_vault_key_id                 = module.stage-keyvault.key_vault_key_id
  user_assigned_identity_id        = module.stage-identity.id
  user_assigned_identity_client_id = module.stage-identity.client_id
  principal_id                     = module.stage-identity.principal_id
  vault_id_output                  = module.stage-keyvault.vault_id_output

  depends_on = [azurerm_resource_group.stage-cloud-native-rg, module.stage-keyvault]
}