resource "azurerm_role_assignment" "example" {
  scope                = var.scope
  role_definition_name = var.role
  principal_id         = var.groupid
}