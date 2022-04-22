
#---------------------------------------------------------------
# Generates SSH2 key Pair for Linux VM's (Dev Environment only)
#---------------------------------------------------------------
resource "tls_private_key" "rsa" {
  count     = var.generate_admin_ssh_key ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}


#---------------------------------------
# Network Interface for Virtual Machine
#---------------------------------------
resource "azurerm_network_interface" "nic" {
  count = var.node_count
  name                          = "nic-${var.virtual_machine_name}-${count.index}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  #dns_servers                   = var.dns_servers
  #enable_ip_forwarding          = var.enable_ip_forwarding
  #enable_accelerated_networking = var.enable_accelerated_networking
  #internal_dns_name_label       = var.internal_dns_name_label
  tags                          = var.tags
  ip_configuration {
    name                          = "ipconfig-${var.virtual_machine_name}-${count.index}"
    primary                       = true
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation_type
    #private_ip_address            = var.private_ip_address_allocation_type == "Static" ? element(concat(var.private_ip_address, [""]), count.index) : null
    #public_ip_address_id          = var.enable_public_ip_address == true ? element(concat(azurerm_public_ip.pip.*.id, [""]), count.index) : null
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

/*resource "azurerm_network_interface_backend_address_pool_association" "backend_attachment" {
  count = var.node_count
  network_interface_id    = azurerm_network_interface.nic[count.index].id
  ip_configuration_name   = "ipconfig-${var.virtual_machine_name}-${count.index}"
  backend_address_pool_id = var.backend_address_pool_id
}*/

#-----------------------------------------------------
# Manages an Availability Set for Virtual Machines.
#-----------------------------------------------------
resource "azurerm_availability_set" "aset" {
  count                        = var.enable_vm_availability_set ? 1 : 0
  name                         = "aset-${var.virtual_machine_name}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  platform_fault_domain_count  = var.platform_fault_domain_count
  platform_update_domain_count = var.platform_update_domain_count
  tags                         = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

#---------------------------------------
# Linux Virutal machine
#---------------------------------------
resource "azurerm_linux_virtual_machine" "linux_vm" {
  count = var.node_count
  name                            = "${var.virtual_machine_name}-${count.index}"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.virtual_machine_size
  admin_username                  = var.admin_username
  network_interface_ids = [element(azurerm_network_interface.nic[*].id, count.index)]
  source_image_id                 = var.source_image_id != null ? var.source_image_id : null
  custom_data                     = var.custom_data != null ? var.custom_data : null
  encryption_at_host_enabled      = var.enable_encryption_at_host
  zone                            = var.vm_availability_zone
  tags                            = var.tags
  #availability_set_id             = var.enable_vm_availability_set == true ? azurerm_availability_set.aset[0].id : null
  user_data = var.user_data

  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication ? [1] : []
    content {
      username   = var.admin_username
      public_key = var.admin_ssh_key_data == null ? tls_private_key.rsa[0].public_key_openssh : file(var.admin_ssh_key_data)
    }
  }
    source_image_reference {

      publisher = var.custom_image["publisher"]
      offer     = var.custom_image["offer"]
      sku       = var.custom_image["sku"]
      version   = var.custom_image["version"]

  }

  os_disk {
    storage_account_type      = var.os_disk_storage_account_type
    caching                   = var.os_disk_caching
    disk_encryption_set_id    = var.disk_encryption_set_id
    disk_size_gb              = var.disk_size_gb
    write_accelerator_enabled = var.enable_os_disk_write_accelerator
    name                      = var.os_disk_name
  }

  additional_capabilities {
    ultra_ssd_enabled = var.enable_ultra_ssd_data_disk_storage_support
  }

  dynamic "identity" {
    for_each = var.managed_identity_type != null ? [1] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.storage_account_uri
    }
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}



/*

#---------------------------------------
# Virtual machine data disks
#---------------------------------------
resource "azurerm_managed_disk" "data_disk" {
  for_each             = local.vm_data_disks
  name                 = "${var.virtual_machine_name}_DataDisk_${each.value.idx}"
  resource_group_name  = var.resource_group_name
  location             = var.location
  storage_account_type = lookup(each.value.data_disk, "storage_account_type", "StandardSSD_LRS")
  create_option        = "Empty"
  disk_size_gb         = each.value.data_disk.disk_size_gb
  tags                 = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  for_each           = local.vm_data_disks
  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.linux_vm[0].id
  lun                = each.value.idx
  caching            = "ReadWrite"
}




#--------------------------------------------
#       AAD Login Extension Installation
#--------------------------------------------
resource "azurerm_virtual_machine_extension" "AADlogin" {
  count = var.node_count
  name                 = "AADSSHLoginForLinux"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux_vm[count.index].id
  publisher            = "Microsoft.Azure.ActiveDirectory.LinuxSSH"
  type                 = "AADLoginForLinux"
  type_handler_version = "1.0"
  settings = ""
}



#--------------------------------------------
#      VM ADMIN Login Role assignment
#--------------------------------------------
resource "azurerm_role_assignment" "VM_ADMIN_LOGIN" {
  count = var.node_count
  scope                = azurerm_linux_virtual_machine.linux_vm[count.index].id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = "***********************************"
}

#--------------------------------------------
#      VM User Login Role assignment
#--------------------------------------------
resource "azurerm_role_assignment" "VM_ADMIN_LOGIN" {
  count = var.node_count  
  scope                = azurerm_linux_virtual_machine.linux_vm[count.index].id
  role_definition_name = "Virtual Machine User Login"
  principal_id         = "********************************"
}

*/