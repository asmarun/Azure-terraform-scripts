output "resource_group_id" {
  description = "Output the object ID"
  value       = azurerm_resource_group.rg.id
}

output "resource_group_name" {
  description = "Output the object name"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Output the object location"
  value       = azurerm_resource_group.rg.location
}

output "tags" {
  description = "Output the object tags"
  value       = azurerm_resource_group.rg.tags
}