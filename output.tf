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
output "subscription_id" {
  description = "Azure subscription ID used for deployment"
  value       = data.azurerm_client_config.current.subscription_id
}

output "tenant_id" {
  description = "Azure tenant ID"
  value       = data.azurerm_client_config.current.tenant_id
}

############################################################
# Output Managed Image Info
############################################################
output "golden_image_id" {
  description = "Managed image ID created from existing VM"
  value       = azurerm_image.golden_image.id
}

output "golden_image_name" {
  description = "Managed image name"
  value       = azurerm_image.golden_image.name
}

############################################################
# Output Shared Image Gallery Info
############################################################
output "sig_name" {
  description = "Shared Image Gallery name"
  value       = azurerm_shared_image_gallery.sig.name
}

output "sig_location" {
  description = "Location of the Shared Image Gallery"
  value       = azurerm_shared_image_gallery.sig.location
}

output "shared_image_definition_name" {
  description = "Shared Image Definition name"
  value       = azurerm_shared_image.sig_image.name
}

output "shared_image_version" {
  description = "Shared Image Version"
  value       = azurerm_shared_image_version.sig_version.name
}

############################################################
# Output New VM Info
############################################################
output "new_vm_name" {
  description = "Name of the newly deployed VM"
  value       = azurerm_linux_virtual_machine.new_vm.name
}

output "new_vm_private_ip" {
  description = "Private IP address of the new VM"
  value       = azurerm_network_interface.new_vm_nic.ip_configuration[0].private_ip_address
}

output "new_vm_nic_id" {
  description = "NIC ID attached to the new VM"
  value       = azurerm_network_interface.new_vm_nic.id
}