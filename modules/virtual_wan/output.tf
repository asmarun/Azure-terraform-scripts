
output "vwan_id" {
  value       = azurerm_virtual_wan.vwan.id
  description = "Echoes back the `name` input variable value, for convenience if passing the result of this module elsewhere as an object."
}

output "easthubid" {
  description = "hub id in the westus"
  value       = azurerm_virtual_hub.vhub["eastus"].id
}

output "westhubid" {
  description = "hub id in the westus"
  value       = azurerm_virtual_hub.vhub["westus"].id
}





output "connections" {
  value       = var.connections
  description = "Echoes back the `connections` input variable value, for convenience if passing the result of this module elsewhere as an object."

 
}