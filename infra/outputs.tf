output "prod_resource_group" {
  value = local.environments.prod.rg_name
}

output "prod_acr" {
  value = module.prod_acr.acr_name
}

output "prod_aks_cluster_name" {
  value = module.prod_aks.aks_cluster_name
}