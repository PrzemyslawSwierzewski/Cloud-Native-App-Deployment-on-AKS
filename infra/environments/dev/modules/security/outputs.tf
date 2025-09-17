output "nsg_id" {
  value       = azurerm_network_security_group.dev_nsg.id
  description = "Output ID of the development Network Security Group"
}
