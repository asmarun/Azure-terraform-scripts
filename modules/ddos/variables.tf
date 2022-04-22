variable "ddosname" {
    type        = string
    description = "name of the DDOS plan on this network"
}

variable "resource_group_name" {
    type        = string
    description = "The resource group name in which to create the resources."
}

variable "resource_group_location" {
    type        = string
    description = "The resource group location in which to create the resources."
}
