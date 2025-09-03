# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "prod_monitoring" {
  name                = local.log_analytics_workspace_name
  location            = var.environment.location
  resource_group_name = var.environment.rg_name
  sku                 = local.log_analytics_workspace_sku
  retention_in_days   = local.log_analytics_workspace_retention_in_days

  tags = {
    Environment = var.environment.name
  }
}

# Wait for workspace to be fully provisioned
resource "time_sleep" "wait_for_workspace" {
  depends_on      = [azurerm_log_analytics_workspace.prod_monitoring]
  create_duration = "30s"
}

# Key Vault Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "keyvault_audit" {
  name                       = local.keyvault_diag_name
  target_resource_id          = var.vault_key_id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log {
    category = "AuditEvent"
  }
}

# AKS Control Plane Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "aks_control_plane" {
  name                      = local.aks_diag_name
  target_resource_id         = var.kubernetes_cluster_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_metric {
    category = local.all_metrics
  }
}

# ACR Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "acr_logs" {
  name                      = local.acr_diag_name
  target_resource_id         = var.acr_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log {
    category = "ContainerRegistryLoginEvents"
  }

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
  }

  enabled_metric {
    category = local.all_metrics
  }
}

# NSG Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "nsg_flow_logs" {
  name                      = local.nsg_diag_name
  target_resource_id         = var.nsg_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log {
    category = "NetworkSecurityGroupFlowEvent"
  }

  enabled_metric {
    category = local.all_metrics
  }
}

# VNet Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "vnet_flow_logs" {
  name                      = local.vnet_diag_name
  target_resource_id         = var.vnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log {
    category = "NetworkSecurityGroupFlowEvent"
  }

  enabled_metric {
    category = local.all_metrics
  }
}

# Action Group
resource "azurerm_monitor_action_group" "alerts" {
  name                = local.prod_alerts
  resource_group_name = var.environment.rg_name
  short_name          = local.prod_alerts

  email_receiver {
    name          = "email_receiver"
    email_address = var.owner_email_address
  }
}

# CPU Alert
resource "azurerm_monitor_metric_alert" "aks_cpu_high" {
  name                = local.cpu_alert_name
  resource_group_name = var.environment.rg_name
  scopes              = [var.kubernetes_cluster_id]
  description         = local.cpu_alert_description
  severity            = var.alert_severity_cpu
  frequency           = local.frequency_of_metric_alerts
  window_size         = local.window_size_of_metric_alerts

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "CPUUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}

# Memory Alert
resource "azurerm_monitor_metric_alert" "aks_memory_high" {
  name                = local.memory_alert_name
  resource_group_name = var.environment.rg_name
  scopes              = [var.kubernetes_cluster_id]
  description         = local.memory_alert_description
  severity            = var.alert_severity_memory
  frequency           = local.frequency_of_metric_alerts
  window_size         = local.window_size_of_metric_alerts

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "MemoryUsage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}
