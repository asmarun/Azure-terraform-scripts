variable "name" {
  type        = string
  description = "The name of the VWAN."
}

variable "allow_branch_to_branch_traffic" {
  type        = bool
  default     = true
  description = "Whether branch to branch traffic is allowed."
}

variable "allow_vnet_to_vnet_traffic" {
  type        = bool
  default     = false
  description = "Whether VNet to VNet traffic is allowed."
}

variable "resource_group_name" {
    type        = string
    description = "The resource group name in which to create the resources."
}

variable "resource_group_location" {
    type        = string
    description = "The resource group location in which to create the resources."
}

variable "hubs" {
  type = map(object({
    name   = string
    prefix = string
  }))

  description = "A list of hubs to create within the virtual WAN."
}


variable "connections" {
  type = map(object({
    region = string
    id     = string
  }))
  description = "A mapping from each region to a list of virtual network IDs to which the virtual hub should be connected."
}

variable "er_gateway" {
  type = map(object({
    name   = string
    region = string
    scale_units = number
  }))
  description = "A list of express route gateways to create within the hub"
  default ={} 
}

variable "firewall" {
  type = map(object({
    name   = string
    region = string
    region = string
  }))

  description = "Firewall to be created in hub"
  
  default ={}
}

variable "log_analytics_workspace_id" {
  type        = string
  description = "log_analytics_workspace id."
}