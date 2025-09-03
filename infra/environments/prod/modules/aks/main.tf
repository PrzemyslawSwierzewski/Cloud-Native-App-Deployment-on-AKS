resource "azurerm_kubernetes_cluster" "prod_cluster" {
  name                = "${var.environment.name}-aks"
  location            = var.environment.location
  resource_group_name = var.environment.rg_name
  dns_prefix          = "${var.environment.name}aks"

  default_node_pool {
    name       = var.default_node_pool.name
    node_count = var.default_node_pool.node_count
    vm_size    = var.default_node_pool.vm_size
    vnet_subnet_id  = var.subnet_id
    auto_scaling_enabled = true
    min_count = var.prod_aks_scaling_min_count
    max_count = var.prod_aks_scaling_max_count
    temporary_name_for_rotation = "${var.environment.name}-aks-temporary"
    zones = ["1", "2", "3"]
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = var.environment.name
  }

  lifecycle {
    ignore_changes = [
      tags, default_node_pool
    ]
  }
}