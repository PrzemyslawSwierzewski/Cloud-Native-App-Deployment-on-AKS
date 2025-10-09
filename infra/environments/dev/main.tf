resource "azurerm_resource_group" "dev-cloud-native-rg" {
  name     = "${local.environments.dev.name}-rg"
  location = local.environments.dev.location
}

module "dev-networking" {
  source      = "../../modules/networking"
  environment = local.environments.dev

  depends_on = [azurerm_resource_group.dev-cloud-native-rg]
}

module "dev-identity" {
  source      = "../../modules/identity"
  environment = local.environments.dev

  depends_on = [azurerm_resource_group.dev-cloud-native-rg]
}

module "dev-security" {
  source      = "../../modules/security"
  environment = local.environments.dev
  subnet_id   = module.dev-networking.subnet_id

  depends_on = [module.dev-networking]
}

module "dev-aks" {
  source                    = "../../modules/aks"
  environment               = local.environments.dev
  default_node_pool         = var.default_node_pools.dev
  subnet_id                 = module.dev-networking.subnet_id
  user_assigned_identity_id = module.dev-identity.id
  aks_scaling_min_count     = var.aks_scaling.dev.min
  aks_scaling_max_count     = var.aks_scaling.dev.max
  principal_id              = module.dev-identity.principal_id
  client_id                 = module.dev-identity.client_id

  depends_on = [module.dev-networking, module.dev-security]
}

module "dev-keyvault" {
  source             = "../../modules/keyvault"
  environment        = local.environments.dev
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

  depends_on = [azurerm_resource_group.dev-cloud-native-rg]
}

module "dev-iam" {
  source                    = "../../modules/iam"
  environment               = local.environments.dev
  vault_key_id              = module.dev-keyvault.vault_id_output
  acr_id                    = module.dev-acr.acr_id
  user_assigned_identity_id = module.dev-identity.principal_id

  depends_on = [module.dev-aks, module.dev-keyvault, module.dev-acr]
}

module "dev-acr" {
  source                           = "../../modules/acr"
  acr_sku                          = var.acr_sku
  environment                      = local.environments.dev
  key_vault_key_id                 = module.dev-keyvault.key_vault_key_id
  user_assigned_identity_id        = module.dev-identity.id
  user_assigned_identity_client_id = module.dev-identity.client_id
  principal_id                     = module.dev-identity.principal_id
  vault_id_output                  = module.dev-keyvault.vault_id_output

  depends_on = [azurerm_resource_group.dev-cloud-native-rg, module.dev-keyvault]
}