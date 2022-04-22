output "admin_ssh_key_public" {
  description = "The generated public key data in PEM format"
  value       = tls_private_key.rsa.*.public_key_openssh
}

output "linux_vm_private_ips" {
  description = "Private IP's map for the all linux Virtual Machines"
  value       = azurerm_linux_virtual_machine.linux_vm.*.private_ip_address
}

output "linux_virtual_machine_id" {
  description = "The resource id of Linux Virtual Machine."
  value       = azurerm_linux_virtual_machine.linux_vm.*.id
}

