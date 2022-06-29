provider "azurerm" {
  features {}

  #  subscription_id = "1f8377a3-e548-4aae-a516-6a1a644c434c"
  #  client_id       = "185d5555-e433-4286-b619-9afc9430f42d"
  #  client_secret   = "ceylvAVDtkLE4XrIvbH0.A15MT-61f1kxg"
  #  tenant_id       = "9ff41cc1-b5be-4a5e-8b1e-cea44886ca5a"
  subscription_id = var.subscription-id
  client_id       = var.client-id
  client_secret   = var.client-secret
  tenant_id       = var.tenant-id
}
resource "azurerm_resource_group" "minatest" {
  name     = "minagithub"
  location = "West Europe"
}
variable "subscription-id" {}
variable "client-id" {}
variable "client-secret" {}
variable "tenant-id" {}
