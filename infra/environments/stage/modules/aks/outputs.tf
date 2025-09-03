output "kubernetes_cluster_id_principal_id" {
  value = azurerm_kubernetes_cluster.dev_cluster.identity[0].principal_id
}