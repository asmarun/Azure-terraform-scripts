data "azurerm_subnet" "snet" {
  name                 = "GatewaySubnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_public_ip" "pip_gw" {
  name                = var.pip1
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  tags                = var.tags
}
/*
resource "azurerm_public_ip" "pip_aa" {
  name                = var.pip2
  location            = var.resource_group_name
  resource_group_name = var.resource_group_location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku
  tags                = var.tags
}*/


#-------------------------------
# Virtual Network Gateway 
#-------------------------------
resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.vpn_gateway_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  type                = var.gateway_type
  vpn_type            = var.gateway_type != "ExpressRoute" ? var.vpn_type : null
  sku                 = var.gateway_type != "ExpressRoute" ? var.vpn_gw_sku : var.expressroute_sku
  #active_active       = var.vpn_gw_sku != "Basic" ? var.enable_active_active : false
  #enable_bgp          = var.vpn_gw_sku != "Basic" ? var.enable_bgp : false
  #generation          = var.vpn_gw_generation

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.pip_gw.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = data.azurerm_subnet.snet.id
  }
 /*
  dynamic "ip_configuration" {
    for_each = var.enable_active_active ? [true] : []
    content {
      name                          = "vnetGatewayAAConfig"
      public_ip_address_id          = azurerm_public_ip.pip_gw.id
      private_ip_address_allocation = "Dynamic"
      subnet_id                     = var.appgwsubnet
    }
  }
*/
}
