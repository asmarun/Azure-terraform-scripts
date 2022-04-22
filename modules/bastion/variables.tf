variable "pip_name" {
    type        = string
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

variable "resource_group_name" {
    type        = string
    description = "The resource group name in which to create the resources."
}

variable "resource_group_location" {
    type        = string
    description = "The resource group location in which to create the resources."
}

variable "bastion_name" {
    type        = string
    description = "name of the bastion Host Name"
}

variable "virtual_network_name" {
    type        = string
    description = "Name of the virtual numwork to get the details of bastion subnet"
}

variable "Bastion_address_prefix" {
    type        = list(string)
    description = "Bastion address range"
}

variable "tags" {
  type        = map(string)
    description = "Resource Tag Values"
}


