resource "azurerm_virtual_network" "aks" {
  name                = "rhk-${var.environment}-vnet"
  address_space       = ["10.0.0.0/8"]
  location            = var.location
  resource_group_name = var.infra_resource_group_name
  subnet {
    name           = "rhk-subnet1"
    address_prefix = "10.240.0.0/16"
  }
  tags = {
    Env             = var.environment
    ApplicationName = "RHK"
  }
}
