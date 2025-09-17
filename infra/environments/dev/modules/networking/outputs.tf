output subnet_id {
  value       = azurerm_subnet.dev-subnet.id
  description = "Output ID of the development subnet"
}

output vnet_id {
  value       = azurerm_virtual_network.dev-vnet.id
  description = "Output ID of the development virtual network"
}