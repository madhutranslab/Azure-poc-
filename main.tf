resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  address_prefixes     = var.subnet_address_prefix
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = "latest"
  }
}
data "external" "sig_check" {
  program = ["bash", "-c", <<EOT
RG_NAME="${azurerm_resource_group.rg.name}"
SIG_NAME="my_shared_gallery"

exists="false"

if az sig show --name "$SIG_NAME" --resource-group "$RG_NAME" >/dev/null 2>&1; then
  exists="true"
fi

# Use $$ to escape $ so Terraform doesn't try to interpolate
echo "{\"exists\": \"$$exists\"}"
EOT
  ]
}

resource "azurerm_shared_image_gallery" "sig" {
  count               = data.external.sig_check.result.exists == "true" ? 0 : 1
  name                = "my_shared_gallery"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  description         = "Shared images for the organization"
}
resource "azurerm_shared_image" "example_image" {
  name                = "linuxImageDef"
  gallery_name        = azurerm_shared_image_gallery.sig[0].name
  resource_group_name = azurerm_shared_image_gallery.sig[0].resource_group_name
  location            = azurerm_shared_image_gallery.sig[0].location
  os_type             = "Linux"
  hyper_v_generation  = "V2"
 
  identifier {
    publisher = "mycompany"
    offer     = "linuxVM"
    sku       = "rhel9"
  }
}
resource "azurerm_shared_image_version" "linux_image_version" {
  name                = "1.0.0"                               # version of the image
  resource_group_name = azurerm_resource_group.rg.name
  gallery_name        = azurerm_shared_image_gallery.sig[0].name
  image_name          = azurerm_shared_image.example_image.name
  location            = azurerm_shared_image_gallery.sig[0].location
   managed_image_id    = azurerm_shared_image.example_image.id

  target_region {
    name                   = azurerm_shared_image_gallery.sig[0].location
    regional_replica_count  = 1        # required: number of replicas in this region
    # optional: storage account type
    # storage_account_type = "Standard_LRS"
  }
}
# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "myVNet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Interface
resource "azurerm_network_interface" "example" {
  name                = "myNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Linux VM
resource "azurerm_linux_virtual_machine" "new_vm" {
  name                  = "myLinuxVM"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22.04-LTS"
    version   = "latest"
  }
}