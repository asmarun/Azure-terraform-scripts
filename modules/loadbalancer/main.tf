data "azurerm_subnet" "snet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_lb" "internal_loadbalancer" {
  name                = var.lb_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = var.ilb_sku
  frontend_ip_configuration {
    name                 = "FE-IP-${var.lb_name}"
    subnet_id                     = data.azurerm_subnet.snet.id
    private_ip_address_allocation = "static"
    private_ip_address            = var.private_ip_address
  }
  tags = var.tags
}
resource "azurerm_lb_backend_address_pool" "loadbalancer_backend" {
  name                = "BE-POOL-${var.lb_name}"
  #resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.internal_loadbalancer.id}"
}

resource "azurerm_lb_probe" "loadbalancer_probe" {
  resource_group_name = "${var.resource_group_name}"
  loadbalancer_id     = "${azurerm_lb.internal_loadbalancer.id}"
  name                = "PROBE-${var.lb_name}"
  protocol            = "tcp"
  port                = var.ports.probe_port
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "lb_rule" {
  resource_group_name            = "${var.resource_group_name}"
  loadbalancer_id                = "${azurerm_lb.internal_loadbalancer.id}"
  name                           = "LB-RULE-${var.lb_name}"
  protocol                       = var.ports.backend_protocol
  frontend_port                  = var.ports.frontend_port
  backend_port                   = var.ports.backend_port
  frontend_ip_configuration_name = "FE-IP-${var.lb_name}"
  backend_address_pool_id        = "${azurerm_lb_backend_address_pool.loadbalancer_backend.id}"
  probe_id                       = "${azurerm_lb_probe.loadbalancer_probe.id}"
}