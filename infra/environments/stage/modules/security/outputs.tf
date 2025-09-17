output "nsg_id" {
  value       = azurerm_network_security_group.stage_nsg.id
  description = "Output ID of the stagining Network Security Group"
}
