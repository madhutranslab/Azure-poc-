output "resource_group_name" {
  description = "The name of the Azure Resource Group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_location" {
  description = "Location of the Azure Resource Group"
  value       = azurerm_resource_group.rg.location
}

# Virtual Network
output "vnet_name" {
  description = "The name of the Virtual Network"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.vnet.address_space
}

# Subnet
output "subnet_id" {
  description = "The ID of the Subnet"
  value       = azurerm_subnet.subnet.id
}

# Public IP
output "public_ip" {
  description = "The Public IP address assigned to the VM"
  value       = azurerm_public_ip.pip.ip_address
}

# Network Security Group
output "nsg_name" {
  description = "The name of the Network Security Group"
  value       = azurerm_network_security_group.nsg.name
}

# Network Interface
output "nic_id" {
  description = "The ID of the Network Interface attached to the VM"
  value       = azurerm_network_interface.nic.id
}

# Linux VM
output "vm_name" {
  description = "The name of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_public_ip" {
  description = "The public IP address of the Linux VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "vm_fqdn" {
  description = "The fully qualified domain name of the Linux VM (if applicable)"
  value       = azurerm_public_ip.pip.fqdn
}