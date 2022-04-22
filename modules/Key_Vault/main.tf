/*resource "random_string" "rand" {
  length  = 8
  special = false
  upper   = false
  lower   = true
}
*/
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv_vault" {
  name                = var.kv_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = local.tenant_id

  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment

  purge_protection_enabled = var.purge_protection_enabled
  tags                     = var.tags

  sku_name = var.sku_name

  #Give access to User or Group to the Key Vault
  dynamic "access_policy" {
    for_each = var.access_policy_settings
    content {
      tenant_id               = local.tenant_id
      object_id               = access_policy.value["object_id"]
      key_permissions         = access_policy.value["key_permissions"]
      secret_permissions      = access_policy.value["secret_permissions"]
      storage_permissions     = access_policy.value["storage_permissions"]
      certificate_permissions = access_policy.value["certificate_permissions"]
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "Key_Vault_DS" {
  name                       = "Key-Vault-DS"
  target_resource_id         = azurerm_key_vault.kv_vault.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"
  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
      days = var.diagnostics_retention_days
    }
  }
  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = true

    retention_policy {
      enabled = true
      days = var.diagnostics_retention_days
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days = var.diagnostics_retention_days
    }
  }
}
/*
resource "azurerm_key_vault_secret" "user_name_secret" {

  name         = var.user_name_secret
  value        = var.user_name_secret_value
  key_vault_id = azurerm_key_vault.kv_vault.id
  #not_before_date = var.activation_date
  #expiration_date = timeadd(var.activation_date, "${var.num_hours_expiration}h")
}

resource "azurerm_key_vault_secret" "private_key_secret" {

  name         = var.private_key_secret_name
  value        = var.private_key_secret_name_value
  key_vault_id = azurerm_key_vault.kv_vault.id
  #not_before_date = var.activation_date
  #expiration_date = timeadd(var.activation_date, "${var.num_hours_expiration}h")
}

resource "azurerm_key_vault_secret" "public_key_secret" {

  name         = var.public_key_secret_name
  value        = var.public_key_secret_name_value
  key_vault_id = azurerm_key_vault.kv_vault.id
  #not_before_date = var.activation_date
  #expiration_date = timeadd(var.activation_date, "${var.num_hours_expiration}h")
}

data "azurerm_key_vault_secret" "public_key_value" {
  name      = var.public_key_secret_name
  key_vault_id = azurerm_key_vault.kv_vault.id
  depends_on = [
    azurerm_key_vault_secret.public_key_secret
  ]
}

data "azurerm_key_vault_secret" "user_name_value" {
  name      = var.user_name_secret
  key_vault_id = azurerm_key_vault.kv_vault.id
  depends_on = [
    azurerm_key_vault_secret.user_name_secret
  ]
}
*/
