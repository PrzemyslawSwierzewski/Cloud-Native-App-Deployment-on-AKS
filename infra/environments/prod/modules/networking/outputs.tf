output subnet_id {
  value       = azurerm_subnet.prod-subnet.id
  description = "Output ID of the production subnet"
}

output vnet_id {
  value       = azurerm_virtual_network.prod-vnet.id
  description = "Output ID of the production virtual network"
}