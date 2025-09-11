locals {

  log_analytics_workspace_name              = "${var.environment.name}-monitoring-workspace"
  log_analytics_workspace_sku               = "PerGB2018"
  log_analytics_workspace_retention_in_days = 30

  keyvault_diag_name = "${var.environment.name}-keyvault-audit-logs"
  aks_diag_name      = "${var.environment.name}-aks-control-plane-logs"
  acr_diag_name      = "${var.environment.name}-acr-logs"
  nsg_diag_name      = "${var.environment.name}-nsg-flow-logs"
  vnet_diag_name     = "${var.environment.name}-vnet-flow-logs"

  keyvault_logs    = ["AuditEvent"]
  aks_logs         = ["kube-apiserver", "kube-audit", "kube-controller-manager", "kube-scheduler"]
  acr_logs         = ["ContainerRegistryLoginEvents", "ContainerRegistryRepositoryEvents"]
  nsg_logs         = ["NetworkSecurityGroupFlowEvent"]
  vnet_logs        = ["NetworkSecurityGroupFlowEvent"]
  all_metrics      = "AllMetrics"

  prod_alerts = "${var.environment.name}-alerts"

  frequency_of_metric_alerts   = "PT5M"
  window_size_of_metric_alerts = "PT5M"

  cpu_alert_name        = "$aks-cpu-alert"
  cpu_alert_description = "Alert if CPU usage exceeds 80% for 5 minutes"

  memory_alert_name        = "$aks-memory-alert"
  memory_alert_description = "Alert if Memory usage exceeds 80% for 5 minutes"

  diag_retention_days = 90
}
