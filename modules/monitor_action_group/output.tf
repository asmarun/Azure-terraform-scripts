output "action_group_id" {

  description = "Output the object location"
  value       = zipmap( values(azurerm_monitor_action_group.action_group)[*].name, values(azurerm_monitor_action_group.action_group)[*].id )
}

