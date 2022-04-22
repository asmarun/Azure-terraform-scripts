variable "vnet_name" {
    type        = string
    description = "name of the virtual network"
}


variable "environment" {
    type        = string
    description = "name of the environment"
}
/*
variable "ddosplanid" {
    type        = string
    description = "the resource ID of DDOS plan"
}*/

variable "resource_group_name" {
    type        = string
    description = "The resource group name in which to create the resources."
}

variable "resource_group_location" {
    type        = string
    description = "The resource group location in which to create the resources."
}

variable "address_space" {
    type        = list
    description = "Network Address space"
}


variable "subnets" {
  type = map(object({
    name            = string
    address_prefix  = list(string)
    network_security_group = string
  }))
  default = {}
}


variable "network_security_group" {
  type = map(object({
    name            = string
  }))
  default = {}
}
/*
variable "security_rule" {
  type = map(object({
    name                        = string
    priority                    = number
    direction                   = string
    access                      = string
    protocol                    = string
    source_port_range           = string
    destination_port_range      = string
    source_address_prefix       = string
    destination_address_prefix  = string
    network_security_group      = string
  }))
  default = {}
}*/

variable "network_security_rules" {
  description = "List of objects that will define the security rules. Required fields are name and priority. Please refer to the variable network_security_rule_defaults for a complete list of options"
  type        = any
  default     = []
}


variable "tags" {
  description = "A mapping of tags which should be assigned to Resources."
  type        = any
  default     = {}
}
variable "log_analytics_workspace_id" {
  type        = string
  description = "log_analytics_workspace id."
}

variable "peering" {
  type        = map(object({
    id  = string
  }))
  description = "Vnet and Hub peering connections"
}


variable "allow_gateway_transit" {
  type        = any
}

variable "use_remote_gateways" {
  type        = any
}

variable "route_table_name" {
  type        = string
  description = "Name of the Route Table"
}

/*
variable "routing_rule_name" {
  type        = string
  description = "Name of the Route Table"
  default = {}
}


variable "rt_address_prefix" {
    type        = list
    description = "he destination CIDR to which the route applies, such as 10.1.0.0/16"
    default = {}
}

variable "next_hop_type" {
  type        = string
  description = "The type of Azure hop the packet should be sent to. Possible values are VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance and None"
  default = {}
}
*/
