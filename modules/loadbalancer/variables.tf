
variable "vnet_name" {
    type        = string
    description = "name of the virtual network"
}

variable "subnet_name" {
    type        = string
    description = "The resource group location in which to create the resources."
}

variable "private_ip_address" {
    type        = string
    description = "lbprivate ip address"
}


variable "ilb_sku" {
    type        = string
    description = "Sku of the Internal Load Balancer. Either 'Basic' or Standard"
}

variable "resource_group_name" {
    type        = string
    description = "The resource group name in which to create the resources."
}

variable "resource_group_location" {
    type        = string
    description = "The resource group location in which to create the resources."
}


variable "lb_name" {
    type        = string
    description = "Name of the Load Balancer"
}

variable "tags" {
  type        = map(string)
    description = "Resource Tag Values"
}


variable "ports" {
  type        = object({
    probe_port    = number
    backend_protocol    = string
    frontend_port    = number
    backend_port     = number
  })
  description = "ports and Protocols"
}