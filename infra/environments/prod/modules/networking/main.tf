resource "azurerm_virtual_network" "prod-vnet" {
  name                = local.vnet_name
  location            = var.environment.location
  resource_group_name = var.environment.rg_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = var.environment.name
  }
}


resource "azurerm_subnet" "prod-subnet" {
  name                 = local.subnet_name
  resource_group_name  = var.environment.rg_name
  virtual_network_name = azurerm_virtual_network.prod-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "prod-subnet-association" {
  subnet_id                 = azurerm_subnet.prod-subnet.id
  network_security_group_id = var.securitygroupid
}
