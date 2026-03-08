# Output the Resource Group name
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.rg.name
}

# Output the Virtual Network details
output "vnet_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.vnet.id
}

# Output the Subnet details
output "subnet_name" {
  description = "The name of the subnet"
  value       = azurerm_subnet.subnet.name
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = azurerm_subnet.subnet.id
}

# Output the Public IP address
output "public_ip_address" {
  description = "The public IP address"
  value       = azurerm_public_ip.pip.ip_address
}

# Output Network Security Group
output "nsg_name" {
  description = "The name of the Network Security Group"
  value       = azurerm_network_security_group.nsg.name
}

# Output Network Interface
output "nic_id" {
  description = "The ID of the Network Interface"
  value       = azurerm_network_interface.nic.id
}

/*# Output Linux VM
output "vm_name" {
  description = "The name of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_public_ip" {
  description = "The public IP of the Linux VM"
  value       = azurerm_public_ip.pip.ip_address
}

# Output Shared Image Gallery and Image
output "sig_name" {
  description = "The name of the Shared Image Gallery"
  value       = azurerm_shared_image_gallery.sig.*.name
}

output "image_name" {
  description = "The name of the Shared Image"
  value       = azurerm_shared_image.example_image.name
}

output "image_version" {
  description = "The version of the Shared Image"
  value       = azurerm_shared_image_version.linux_image_version.name
}

# Output additional VM and Network details for the second VM
output "new_vm_name" {
  description = "The name of the second Linux VM"
  value       = azurerm_linux_virtual_machine.new_vm.name
}

output "new_vm_nic_id" {
  value = azurerm_network_interface.new_vm_nic.id
}*/

############################################################
# Output Subscription and Tenant Info
############################################################
output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.example.name
}

output "vm_name" {
  description = "Virtual Machine Name"
  value       = azurerm_linux_virtual_machine.example.name
}

output "vm_id" {
  description = "Virtual Machine ID"
  value       = azurerm_linux_virtual_machine.example.id
}

output "vm_private_ip" {
  description = "Private IP Address of VM"
  value       = azurerm_network_interface.example.private_ip_address
}

output "network_interface_id" {
  description = "Network Interface ID"
  value       = azurerm_network_interface.example.id
}

output "shared_image_gallery_name" {
  description = "Compute Gallery Name"
  value       = data.azurerm_shared_image_gallery.example.name
}

output "shared_image_name" {
  description = "Shared Image Name"
  value       = data.azurerm_shared_image.example.name
}

output "shared_image_version_id" {
  description = "Shared Image Version ID"
  value       = data.azurerm_shared_image_version.example.id
}