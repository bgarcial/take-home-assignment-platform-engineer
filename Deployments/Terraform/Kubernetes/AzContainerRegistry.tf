resource "azurerm_container_registry" "acr" {
  name                     = var.registry_name
  resource_group_name      = var.infra_resource_group_name
  location                 = var.location
  sku                      = "Standard"
  admin_enabled            = true
}