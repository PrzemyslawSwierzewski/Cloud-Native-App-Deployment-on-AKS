resource "azurerm_kubernetes_cluster" "dev_cluster" {
  name                = "${var.environment.name}-aks"
  location            = var.environment.location
  resource_group_name = var.environment.rg_name
  dns_prefix          = "${var.environment.name}aks"

  default_node_pool {
    name       = var.default_node_pool.name
    node_count = var.default_node_pool.node_count
    vm_size    = var.default_node_pool.vm_size
    vnet_subnet_id  = var.subnet_id
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