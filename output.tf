# Output the Resource Group name
/*output "resource_group_name" {
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

# Output Linux VM
output "vm_name" {
  description = "The name of the Linux VM"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_public_ip" {
  description = "The public IP of the Linux VM"
  value       = azurerm_public_ip.pip.ip_address
}
*/
#####################################################################

output "vm_id" {
  description = "The ID of the Linux VM"
  value       = azurerm_linux_virtual_machine.example.id
}

output "vm_private_ip" {
  description = "Private IP address of the VM"
  value       = azurerm_network_interface.example.private_ip_address
}

output "vm_public_ip" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.pip.ip_address
}

output "nic_id" {
  description = "Network Interface ID"
  value       = azurerm_network_interface.example.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = azurerm_subnet.example.id
}

output "nsg_id" {
  description = "Network Security Group ID"
  value       = azurerm_network_security_group.example.id
}