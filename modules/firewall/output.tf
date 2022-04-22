
output "id" {
  description = "Output the Firewall ID"
  value = azurerm_firewall.firewall.id
}

output "name" {
  description = "Output the Firewall name"
  value  = azurerm_firewall.firewall.name
}