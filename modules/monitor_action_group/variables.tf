
variable "tags" {
  type        = map(string)
  description = "Tags to apply to the storage account and solutions."
  default     = {}
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to deploy the alert group in to."
}

variable "action_group_definitions" {
  description = "A map of alert group definitions."
}