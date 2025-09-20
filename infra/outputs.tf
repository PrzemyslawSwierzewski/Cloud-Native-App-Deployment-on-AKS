output "prod_resource_group" {
  value = local.environments.prod.rg_name
}

output "prod_acr" {
  value = module.prod_acr.acr_name
}

output "prod_aks_cluster_name" {
  value = module.prod_aks.aks_cluster_name
}

output "key_vault_name" {
  value = module.prod_keyvault.key_vault_name
}

output "user_assigned_identity_client_id" {
  value = module.prod_identity.client_id
}

data "azurerm_client_config" "current" {}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

# output "staging_resource_group" {
#   value = local.environments.stage.rg_name
# }

# output "staging_acr" {
#   value = module.stage_acr.acr_name
# }

# output "staging_aks_cluster_name" {
#   value = module.stage_aks.aks_cluster_name
# }

# output "dev_resource_group" {
#   value = local.environments.dev.rg_name
# }

# output "dev_acr" {
#   value = module.dev_acr.acr_name
# }

# output "dev_aks_cluster_name" {
#   value = module.dev_aks.aks_cluster_name
# }.