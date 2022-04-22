output "kv_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.kv_vault.id
}

output "kv_uri" {
  description = "The URI of the Key Vault, used for performing operations on keys and secrets."
  value       = azurerm_key_vault.kv_vault.vault_uri
}

output "kv_name" {
  description = "The name of the keyvault"
  value       = azurerm_key_vault.kv_vault.name
}

output "kv_object" {
  description = "keyvault object"
  value       = azurerm_key_vault.kv_vault
}
/*
output "username" {
  value       = azurerm_key_vault_secret.user_name_secret.id
  description = "Secret that is stored in keyvault"
  sensitive   = true
}

output "private_key" {
  value       = azurerm_key_vault_secret.private_key_secret.id
  description = "Secret that is stored in keyvault"
  sensitive   = true
}
output "public_key" {
  value       = azurerm_key_vault_secret.public_key_secret.id
  description = "Secret that is stored in keyvault"
  sensitive   = true
}
output "public_key_value" {
  value = data.azurerm_key_vault_secret.public_key_value.value
  sensitive   = true
}

output "username_value" {
  value       = data.azurerm_key_vault_secret.user_name_value.value
  sensitive   = true
}
*/