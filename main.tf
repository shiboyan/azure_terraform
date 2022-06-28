provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "minatest" {
  name     = "minagithub"
  location = "West Europe"
}
