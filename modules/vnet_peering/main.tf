resource "azurerm_virtual_network_peering" "peering" {
  for_each                  = var.peerings
  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.source_vnet_name
  remote_virtual_network_id = each.value.destination_vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = var.allow_gateway_transit
}