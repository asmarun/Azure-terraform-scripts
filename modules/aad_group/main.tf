
data "azuread_client_config" "current" {}

resource "azuread_group" "groups" {
  for_each = var.aad_groups
  behaviors               = []
  display_name        = each.value.name
  #prevent_duplicate_names = true
  #description         = each.value.description
  #owners              = [data.azuread_client_config.current.object_id]
    prevent_duplicate_names = true
  provisioning_options    = []
  security_enabled        = true
  types                   = []
  members = ["66006a26-ce4e-41f1-9dd8-56667f639fea"]
}