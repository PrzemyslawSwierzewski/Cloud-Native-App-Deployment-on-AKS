output "nsg_id" {
  value       = azurerm_network_security_group.prod_nsg.id
  description = "Output ID of the production Network Security Group"
}
