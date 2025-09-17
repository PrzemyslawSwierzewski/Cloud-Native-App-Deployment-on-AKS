output "kubernetes_cluster_id_principal_id" {
  value = azurerm_kubernetes_cluster.stage_cluster.identity[0].principal_id
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.stage_cluster.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.stage_cluster.name
}