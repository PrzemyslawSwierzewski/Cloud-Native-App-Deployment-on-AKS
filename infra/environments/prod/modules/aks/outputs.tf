output "kubernetes_cluster_id_principal_id" {
  value = azurerm_kubernetes_cluster.prod_cluster.identity[0].principal_id
}

output "kubernetes_cluster_id" {
  value = azurerm_kubernetes_cluster.prod_cluster.id
}