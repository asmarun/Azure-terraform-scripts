variable "name" {
  type        = string
  description = "The name of the Log Analytics Workspace."
}

variable "resource_group_name" {
    type        = string
    description = "The resource group name in which to create the resources."
}

variable "resource_group_location" {
    type        = string
    description = "The resource group location in which to create the resources."
}

variable "sku" {
    type        = string
    description = "SKU of the log analytics workspace."
    default = "PerGB2018"
}

variable "retention_in_days" {
    type        = number
    description = "retention of the log analytics workspace."
    default = 365
}

variable "solutions" {
  type = map(object({
    solution_name = string
    publisher     = string
    product       = string 
  }))

  description = "Solutions that need to be enabled on log analytics workspace."
}
variable "tags" {
  type        = map(string)
    description = "Resource Tag Values"
}