terraform {
  backend "azurerm" {
    container_name = "rhkterraformstates"
    # Same name that blob container CONTAINER_NAME=rhkterraformstates env variable in bash file
  }
}