resource "azurerm_log_analytics_workspace" "main" {
  name                = var.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  tags = var.tags
}


resource "azurerm_log_analytics_solution" "la_solution" {
  for_each              = var.solutions
  solution_name         = each.value.solution_name
  location              = var.resource_group_location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
      product   = each.value.product
      publisher = each.value.publisher
    }
  tags = var.tags  

}