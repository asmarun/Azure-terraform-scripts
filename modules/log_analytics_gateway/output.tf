output "law_id" {
  description = "Output the object ID"
  value       = azurerm_log_analytics_workspace.main.id
}
output "primary_shared_key" {
  description = "Output the object ID"
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
}
output "workspace_id" {
  description = "Output the object ID"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}
output "name" {
  description = "Output the object name"
  value       = azurerm_log_analytics_workspace.main.name
}
output "object" {
  sensitive   = true
  description = "Output the full object"
  value       = azurerm_log_analytics_workspace.main
}