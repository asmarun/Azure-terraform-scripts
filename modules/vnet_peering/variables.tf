variable "peerings" {
  type = map(object({
    name                 = string
    resource_group_name  = string
    source_vnet_name     = string
    destination_vnet_id  = string
  }))
  default = {}
}

variable "allow_gateway_transit" {
  type        = any
}