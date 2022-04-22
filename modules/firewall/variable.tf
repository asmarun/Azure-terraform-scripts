
variable "azurerm_firewall_name" {
  type         = string
  description = "azurerm firewall name"  
}


variable "resource_group_location" {
  type         = string
  description = "resource group location"  
}
variable "resource_group_name" {
  type         = string
  description = "resource group name"  
}

variable "virtual_network_name" {
  type         = string
  description = "virtual network name"  
}
variable "pip_name" {
  type         = string
  description = "name of the Public IP"  
}

variable "allocation_method" {
    type        = string
    default = "Static"
    description = "Allocation Meathod of public IP"
}

variable "sku" {
    type        = string
    default = "Standard"
    description = "Public IP SKU"
}

variable "firewallsubnetprefix" {
  type         = list(string)
  description = "firewall subnet name"  
}


variable "log_analytics_workspace_id" {
  type        = string
  description = "log_analytics_workspace id."
}

variable "tags" {
  description = "A mapping of tags which should be assigned to Resources."
  type        = any
  default     = {}
}

variable "firewall_application_rules" {
  description = "Microsoft-managed virtual network that enables connectivity from other resources."
  type = list(object({
    name             = string
    description      = string
    action           = string
    source_addresses = list(string)
    source_ip_groups = list(string)
    fqdn_tags        = list(string)
    target_fqdns     = list(string)
    protocol = object({
      type = string
      port = string
    })
  }))
  default = []
  #The Optional values are description, source_addresses, source_ip_groups, fqdn_tags, target_fqdns and protocol  
}

variable "firewall_network_rules" {
  description = "List of network rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = string 
    action                = string
    source_addresses      = list(string)
    destination_ports     = list(string)
    destination_addresses = list(string)
    destination_fqdns     = list(string)
    protocols             = list(string)
  }))
  default = []
  #The Optional values are description, source_addresses, destination_addresses, destination_fqdns
}

variable "firewall_nat_rules" {
  description = "List of nat rules to apply to firewall."
  type = list(object({
    name                  = string
    description           = string
    action                = string
    source_addresses      = list(string)
    destination_ports     = list(string)
    destination_addresses = list(string)
    protocols             = list(string)
    translated_address    = string
    translated_port       = string
  }))
  default = []
  #The Optional values are description, source_addresses  
}
