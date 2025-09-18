output "subnet_id" {
  value       = azurerm_subnet.stage-subnet.id
  description = "Output ID of the staging subnet"
}

output "vnet_id" {
  value       = azurerm_virtual_network.stage-vnet.id
  description = "Output ID of the staging virtual network"
}