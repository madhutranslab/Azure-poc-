resource_group_name = "linux-rg"
location            = "australiaeast"

vnet_name           = "linux-vnet"
vnet_address_space  = ["10.0.0.0/16"]

subnet_name         = "linux-subnet"
subnet_address_prefix = ["10.0.0.0/24"]

public_ip_name      = "linux-public-ip"

nsg_name            = "linux-nsg"

nic_name            = "linux-nic"

vm_name             = "linux-vm"
vm_size             = "Standard_D2s_v3"
admin_username      = "azureuser"

ssh_public_key_path = "C:/Users/MadhuDS/.ssh/id_rsa.pub"

image_publisher     = "RedHat"
image_offer         = "RHEL"
image_sku           = "9-lvm-gen2"

sig_name            = "my_shared_gallery"
image_definition_name = "linuxImageDef"

new_vm_name = "madhu"