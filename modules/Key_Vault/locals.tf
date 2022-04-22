#Local Variables
locals {
  tenant_id      = data.azurerm_client_config.current.tenant_id
  #kv_name        = "${var.kv_name}-kv-${random_string.rand.result}"
}
