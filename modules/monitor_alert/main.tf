
resource "azurerm_monitor_activity_log_alert" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  scopes              = [var.resource_group_id]
  description         = "This alert will monitor a vnet peering updates."
  criteria {
    category       = var.category
    operation_name = var.operation_name
  }
  action {
    action_group_id    = var.azurerm_monitor_action_group_id
    webhook_properties = var.webhook_properties
  }
  tags = var.tags
}