
resource "azurerm_virtual_wan" "vwan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  allow_branch_to_branch_traffic = var.allow_branch_to_branch_traffic
}

resource "azurerm_virtual_hub" "vhub" {
  for_each            = var.hubs
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.key
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = each.value.prefix
}

resource "azurerm_virtual_hub_connection" "connection" {
  for_each                  = var.connections
  name                      = "HUB-CONNECTION-${each.key}"
  virtual_hub_id            = azurerm_virtual_hub.vhub[each.value.region].id
  remote_virtual_network_id = each.value.id
}

resource "azurerm_express_route_gateway" "erg" {
  for_each            = var.er_gateway
  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = each.value.region
  virtual_hub_id      = azurerm_virtual_hub.vhub[each.value.region].id
  scale_units         = 1
  depends_on = [
    azurerm_virtual_hub.vhub
  ]
}


resource "azurerm_firewall" "azfw" {
  for_each            = var.firewall
  name                = each.value.name
  location            = each.value.region
  resource_group_name = var.resource_group_name
  sku_name = "AZFW_Hub"
  threat_intel_mode   = ""
  virtual_hub { virtual_hub_id = azurerm_virtual_hub.vhub[each.value.region].id }
}


resource "azurerm_monitor_diagnostic_setting" "firewallDS" {
  for_each                   = var.firewall
  name                       = "firewallDS"
  target_resource_id         = azurerm_firewall.azfw[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"
  log {
    category = "AzureFirewallApplicationRule"
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureFirewallNetworkRule"
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "AzureFirewallDnsProxy"
    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}