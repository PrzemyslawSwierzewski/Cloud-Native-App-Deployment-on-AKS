resource "azurerm_role_assignment" "aks_mi_operator" {
  scope                = var.user_assigned_identity_id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.principal_id   # control plane principal_id (not from the cluster resource)
}


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
    temporary_name_for_rotation = "${var.environment.name}temp"
    zones = ["3"]
  }

  kubelet_identity{
    client_id = var.client_id
    object_id = var.principal_id
    user_assigned_identity_id = var.user_assigned_identity_id
  }
  
  identity {
    type = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  tags = {
    Environment = var.environment.name
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.1.0.0/16"      # non-overlapping with VNet
    dns_service_ip     = "10.1.0.10"        # inside service_cidr
  }

  lifecycle {
    ignore_changes = [
      default_node_pool.upgrade_settings
    ]
  }

  depends_on = [azurerm_role_assignment.aks_mi_operator]
}