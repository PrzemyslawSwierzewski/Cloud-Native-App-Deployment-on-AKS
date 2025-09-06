############################################
# Log Analytics Workspace
############################################
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

############################################
# Key Vault Diagnostic Settings
############################################
resource "azurerm_monitor_diagnostic_setting" "keyvault_audit" {
  name                        = local.keyvault_diag_name
  target_resource_id          = var.vault_key_id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log {
    category = "AuditEvent"
  }

  depends_on = [azurerm_log_analytics_workspace.prod_monitoring]
}

############################################
# AKS Control Plane Diagnostic Settings
############################################
resource "azurerm_monitor_diagnostic_setting" "aks_control_plane" {
  name                       = local.aks_diag_name
  target_resource_id         = var.kubernetes_cluster_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log { category = "kube-apiserver" }
  enabled_log { category = "kube-audit" }
  enabled_log { category = "kube-controller-manager" }
  enabled_log { category = "kube-scheduler" }

  enabled_metric {
    category = local.all_metrics
  }

  depends_on = [azurerm_log_analytics_workspace.prod_monitoring]
}

############################################
# ACR Diagnostic Settings
############################################
resource "azurerm_monitor_diagnostic_setting" "acr_logs" {
  name                       = local.acr_diag_name
  target_resource_id         = var.acr_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_log { category = "ContainerRegistryLoginEvents" }
  enabled_log { category = "ContainerRegistryRepositoryEvents" }

  enabled_metric {
    category = local.all_metrics
  }

  depends_on = [azurerm_log_analytics_workspace.prod_monitoring]
}

############################################
# VNet Diagnostic Settings (metrics only)
############################################
resource "azurerm_monitor_diagnostic_setting" "vnet_metrics" {
  name                       = local.vnet_diag_name
  target_resource_id         = var.vnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.prod_monitoring.id

  enabled_metric {
    category = local.all_metrics
  }

  depends_on = [azurerm_log_analytics_workspace.prod_monitoring]
}

############################################
# Action Group
############################################
resource "azurerm_monitor_action_group" "alerts" {
  name                = local.prod_alerts
  resource_group_name = var.environment.rg_name
  short_name          = local.prod_alerts

  email_receiver {
    name          = "email_receiver"
    email_address = var.owner_email_address
  }

  depends_on = [azurerm_log_analytics_workspace.prod_monitoring]
}

############################################
# AKS CPU Alert
############################################
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
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }

  depends_on = [azurerm_log_analytics_workspace.prod_monitoring]
}
