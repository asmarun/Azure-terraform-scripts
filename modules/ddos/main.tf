resource "azurerm_network_ddos_protection_plan" "ddos" {
  name                = var.ddosname
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
}