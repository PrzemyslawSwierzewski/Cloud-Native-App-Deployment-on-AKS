resource "azurerm_role_assignment" "aks_mi_operator" {
  scope                = var.user_assigned_identity_id
  role_definition_name = "Managed Identity Operator"
  principal_id         = var.principal_id
}


resource "azurerm_kubernetes_cluster" "cloud-native-cluster" {
  name                = "${var.environment.name}-aks"
  location            = var.environment.location
  resource_group_name = var.environment.rg_name
  dns_prefix          = "${var.environment.name}aks"

  default_node_pool {
    name                        = var.default_node_pool.name
    node_count                  = var.default_node_pool.node_count
    vm_size                     = var.default_node_pool.vm_size
    vnet_subnet_id              = var.subnet_id
    auto_scaling_enabled        = true
    min_count                   = var.aks_scaling_min_count
    max_count                   = var.aks_scaling_max_count
    temporary_name_for_rotation = "${var.environment.name}temp"
    zones                       = ["3"]
  }

  monitor_metrics {
    annotations_allowed = var.metric_annotations_allowlist
    labels_allowed      = var.metric_labels_allowlist
  }

  kubelet_identity {
    client_id                 = var.client_id
    object_id                 = var.principal_id
    user_assigned_identity_id = var.user_assigned_identity_id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  tags = {
    Environment = var.environment.name
  }

  network_profile {
    network_plugin = "azure"
    service_cidr   = "10.1.0.0/16" # non-overlapping with VNet
    dns_service_ip = "10.1.0.10"   # inside service_cidr
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].upgrade_settings
    ]
  }

  key_vault_secrets_provider {
    secret_rotation_enabled = false
  }

  depends_on = [azurerm_role_assignment.aks_mi_operator]
}