provider "azurerm" {
  features {}

}
resource "azurerm_resource_group" "minatest" {
  name     = "minagithub"
  location = "West Europe"
}
#variable "subscription-id" {}
#variable "client-id" {}
#variable "client-secret" {}
#variable "tenant-id" {}
