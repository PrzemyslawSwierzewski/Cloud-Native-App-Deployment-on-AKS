resource "azurerm_virtual_network" "stage-vnet" {
  name                = local.vnet_name
  location            = var.environment.location
  resource_group_name = var.environment.rg_name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = var.environment.name
  }
}


resource "azurerm_subnet" "stage-subnet" {
  name                 = local.subnet_name
  resource_group_name  = var.environment.rg_name
  virtual_network_name = azurerm_virtual_network.stage-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}
