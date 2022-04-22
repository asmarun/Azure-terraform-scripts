
resource "azurerm_virtual_network" "vnet" {
  name                      = var.vnet_name
  location                  = var.resource_group_location
  resource_group_name       = var.resource_group_name
  address_space             = var.address_space
  tags                      = var.tags
  /*
  ddos_protection_plan {
    id     = var.ddosplanid
    enable = false
  }*/
}

resource "azurerm_monitor_diagnostic_setting" "VNETDS" {
  name                       = "VNETDS"
  target_resource_id         = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log {
    category = "VMProtectionAlerts"
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

resource "azurerm_virtual_network_peering" "peering" {
  for_each                  = var.peering
  name                      = "hub-peering-${each.key}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = each.value.id
  allow_gateway_transit = var.allow_gateway_transit
  use_remote_gateways = var.use_remote_gateways
  allow_forwarded_traffic      = true
}


resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefix
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = var.network_security_group
  name                = each.value.name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}


resource "azurerm_subnet_network_security_group_association" "nsgassn" {

 for_each = {for a, subnet in var.subnets : a => subnet if subnet.network_security_group != ""}
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.network_security_group].id
  depends_on = [
    azurerm_network_security_group.nsg, azurerm_network_security_rule.nsg_rule
  ]
}

resource "azurerm_monitor_diagnostic_setting" "DS" {
  for_each                   = var.network_security_group
  name                       = "NSGDS"
  target_resource_id         = azurerm_network_security_group.nsg[each.key].id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log {
    category = "NetworkSecurityGroupEvent"
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "NetworkSecurityGroupRuleCounter"
    retention_policy {
      enabled = false
    }
  }
}


resource "azurerm_network_security_rule" "nsg_rule" {
  for_each = {
    for key, value in var.network_security_rules : key => value
  }
  name                         = each.value.name
  priority                     = each.value.priority
  direction                    = each.value.direction
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_port_range            = length(each.value.source_port_ranges) > 1 ? null : each.value.source_port_ranges[0]
  source_port_ranges           = length(each.value.source_port_ranges) > 1 ? each.value.source_port_ranges : null
  destination_port_range       = length(each.value.destination_port_ranges) > 1 ? null : each.value.destination_port_ranges[0]
  destination_port_ranges      = length(each.value.destination_port_ranges) > 1 ? each.value.destination_port_ranges : null
  source_address_prefix        = lookup(each.value, "source_address_prefixes", null) == null ? each.value.source_address_prefix : null
  source_address_prefixes      = lookup(each.value, "source_address_prefixes", null)
  destination_address_prefix   = lookup(each.value, "destination_address_prefixes", null) == null ? each.value.destination_address_prefix : null
  destination_address_prefixes = lookup(each.value, "destination_address_prefixes", null)
  resource_group_name          = var.resource_group_name
  network_security_group_name  = azurerm_network_security_group.nsg[each.value.nsgname].name
}

# route_table
#-------------------------------------------------
resource "azurerm_route_table" "rt" {
  name                = var.route_table_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  tags                = var.tags
}

/*
# Route table to subnet association 
resource "azurerm_subnet_route_table_association" "rtassoc" {
  for_each       = var.subnets
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.rt.id
}

# Routing Rules
resource "azurerm_route" "rt" {
  name                   = var.routing_rule_name
  resource_group_name    = var.resource_group_name
  route_table_name       = var.route_table_name
  address_prefix         = var.rt_address_prefix
  next_hop_type          = var.next_hop_type  
}
*/


