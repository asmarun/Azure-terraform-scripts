variable "resource_group_name" {
  type        = string
  description = "The resource group the Key Vault shold be placed"
}

variable "location" {
  description = "Azure region where Key vault should be deployed"
  type        = string
}

variable "kv_name" {
  description = "Name of the Key Vault prefix (eg PREFIX-kv-generatedRandomstring). 3-24 characters allowed"
  type        = string
  default     = "CHANGEKVNAME"
}

variable "network_acl_subnet_ids" {
  type        = list(string)
  description = "Allowed Subnet list identified by id"
  default     = []
}

variable "network_acl_ips" {
  type        = list(string)
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault."
  default     = []
}

variable "tags" {
  description = "A mapping of custom tags"
  type        = map(any)
  default     = {}
}

variable "enabled_for_disk_encryption" {
  description = "Enable for Disk Encryption"
  type        = bool
  default     = true
}

variable "enabled_for_deployment" {
  type        = bool
  description = "Enable for VM Deployment"
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Enable for Template Deployment"
  type        = bool
  default     = false
}

variable "purge_protection_enabled" {
  description = "Enable Purge Protection. Now Azure does not provide an option to disable this feature "
  type        = bool
  default     = true
}

variable "access_policy_settings" {
  description = "Access policy settings"
  type = list(object({
    object_id               = string
    key_permissions         = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
    certificate_permissions = list(string)
  }))
  /*#Allowed Values for above variable
  {
      object_id               = "User or Group Object ID"
      key_permissions         = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore"]
      secret_permissions      = ["Get","List","Set","Delete","Recover","Backup","Restore"],
      storage_permissions     = [],
      certificate_permissions = ["Get","List","Update","Create","Import","Delete","Recover","Backup","Restore","ManageContacts","ManageIssuers","GetIssuers","ListIssuers","SetIssuers", "DeleteIssuers"]
    }]*/
}

variable "diagnostics_retention_days" {
  description = "Number of days to keep the diagnostic logs"
  type        = number
  default     = 30
}

variable "sku_name" {
  description = "Default SKU of the KeyVault"
  type        = string
  default     = "premium"
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  type        = string
  default     = null
}

variable "keyvault_diagnostics" {
  description = "Diagnostic settings for KeyVault"
  type = object({
    logs    = list(string)
    metrics = list(string)
  })
  default = {
    logs    = ["AuditEvent"]
    metrics = ["AllMetrics"]
  }
}


/*
variable "user_name_secret" {
  type        = string
  description = "Name of the User name Key-Vault Secret."
}

variable "user_name_secret_value" {
  type        = string
  default     = null
  description = "Key Vault Secret value of VM user name should be passed here"
}

variable "private_key_secret_name" {
  type        = string
  description = "Name of the private key Key-Vault Secret."
}


variable "private_key_secret_name_value" {
  type        = string
  default     = null
  description = "Key Vault Secret value of Private Key should be passed here"
}

variable "public_key_secret_name" {
  type        = string
  description = "Name of the public key Key-Vault Secret."
}

variable "public_key_secret_name_value" {
  type        = string
  default     = null
  description = "Key Vault Secret value of Public Key should be passed here"
}
*/
/* ###Use this for setting expiration and activation of certificates and Secrets
variable "num_hours_expiration" {
  description = "Number of hours for secret expiration. Maximum value is 17520 hours (2 years)"
  type        = number

  validation {
    condition = (
      var.num_hours_expiration > 0 &&
      var.num_hours_expiration < 17521
    )
    error_message = "The num_hours_expiration value must be between 1-17520."
  }
  default = 17521
}

variable "activation_date" {
  description = "The date the secret becomes available in UTC in RFC 3339 datetime format (YYYY-mm-ddTH:M:SZ)"
  type        = string
  validation {
    condition = (
      length(regexall("^[1-9]\\d{3}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z$", var.activation_date)) == 1
    )
    error_message = "Activation date format does not match RFC3339."
  }
}
*/



