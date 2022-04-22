output "virtual_network_id" {
  description = "Output the object ID"
  value       = azurerm_virtual_network.vnet.id
}

output "virtual_network_name" {
  description = "Output the object ID"
  value       = azurerm_virtual_network.vnet.name
}

output "virtual_network_address_space" {
  description = "Output the object ID"
  value       = azurerm_virtual_network.vnet.address_space
}

output "subnet_ids" {
  description = "List of IDs of subnets"
  value       = {
    for s, subnet in azurerm_subnet.subnet : s => subnet.id
  }
}
