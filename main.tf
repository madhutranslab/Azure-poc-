
# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Virtual Network and Subnet
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


# Public IP
resource "azurerm_public_ip" "pip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


# Network Security Group
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

# Network Interface
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

# Original Linux VM (to capture)

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

/*############################################################
# Shared Image Gallery
############################################################
resource "azurerm_shared_image_gallery" "sig" {
  name                = "my_shared_gallery"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  description         = "Shared images for the organization"

  lifecycle {
    ignore_changes = [description]
  }
}

############################################################
# Shared Image Definition
############################################################
resource "azurerm_shared_image" "example_image" {
  name                = "linuxImageDef"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"


  identifier {
    publisher = "mycompany"
    offer     = "linuxVM"
    sku       = "rhel9"
  }
}

############################################################
# Managed Image from VM
############################################################
data "azurerm_virtual_machine" "example" {
  name                = "examplevm"
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_image" "my_managed_image" {
  name                      = "linuxManagedImage"
  location                  = data.azurerm_virtual_machine.example
  resource_group_name       = data.azurerm_resource_group.rg.name
  source_virtual_machine_id = data.azurerm_linux_virtual_machine.vm.id
}

############################################################
# Shared Image Version
############################################################
resource "azurerm_shared_image_version" "linux_image_version" {
  name                = "1.0.0"
  resource_group_name = azurerm_resource_group.rg.name
  gallery_name        = azurerm_shared_image_gallery.sig.name
  image_name          = azurerm_shared_image.example_image.name
  location            = azurerm_resource_group.rg.location

  managed_image_id = azurerm_image.my_managed_image.id

  target_region {
    name                   = azurerm_resource_group.rg.location
    regional_replica_count  = 1
    storage_account_type   = "Standard_LRS"
  }
}

############################################################
# New Linux VM from Shared Image
############################################################
resource "azurerm_network_interface" "new_vm_nic" {
  name                = "newVmNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "new_vm" {
  name                  = "myLinuxVMNew"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.new_vm_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
  publisher = "RedHat"       # Correct publisher
  offer     = "RHEL"         # Correct offer
  sku       = "9-gen2"       # Available SKU in your region
  version   = "latest"       # Must be a string
}
  }
############################################################
# Shared Image Gallery
############################################################
resource "azurerm_shared_image_gallery" "sig" {
  name                = "my_shared_gallery"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  description         = "Shared images for the organization"

  lifecycle {
    ignore_changes = [description]
  }
}

############################################################
# Shared Image Definition
############################################################
resource "azurerm_shared_image" "example_image" {
  name                = "linuxImageDef"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"

  identifier {
    publisher = "mycompany"
    offer     = "linuxVM"
    sku       = "rhel9"
  }
}

############################################################
# Capture Existing VM as Managed Image
############################################################
data "azurerm_virtual_machine" "existing_vm" {
  name                = "examplevm"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_image" "my_managed_image" {
  name                      = "linuxManagedImage"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  source_virtual_machine_id = data.azurerm_virtual_machine.existing_vm.id
}

############################################################
# Shared Image Version
############################################################
resource "azurerm_shared_image_version" "linux_image_version" {
  name                = "1.0.0"
  resource_group_name = azurerm_resource_group.rg.name
  gallery_name        = azurerm_shared_image_gallery.sig.name
  image_name          = azurerm_shared_image.example_image.name
  location            = azurerm_resource_group.rg.location

  managed_image_id = azurerm_image.my_managed_image.id

  target_region {
    name                  = azurerm_resource_group.rg.location
    regional_replica_count = 1
    storage_account_type  = "Standard_LRS"
  }
}

############################################################
# Network Interface for New VM
############################################################
resource "azurerm_network_interface" "new_vm_nic" {
  name                = "newVmNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

############################################################
# Deploy Linux VM from Shared Image
############################################################
resource "azurerm_linux_virtual_machine" "new_vm" {
  name                  = "myLinuxVMNew"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.new_vm_nic.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  # Use the Shared Image Gallery version
  source_image_id = azurerm_shared_image_version.linux_image_version.id
}*/

# Get subscription and tenant info

# ─────────────────────────────────────────

# STEP 1 — Deprovision Inside VM

# ─────────────────────────────────────────

resource "null_resource" "deprovision_vm" {
 
  triggers = {

    vm_name    = var.vm_name

    always_run = timestamp()

  }
 
  provisioner "remote-exec" {

    inline = [

      # ✅ Log start

      "echo '========================================='",

      "echo 'STEP 1: Starting VM Deprovision...'",

      "echo 'Timestamp: ' $(date)",

      "echo 'Hostname: ' $(hostname)",

      "echo '========================================='",
 
      # ✅ Run deprovision

      "sudo waagent -deprovision+user -force 2>&1 | tee /tmp/deprovision.log",
 
      # ✅ Log completion

      "echo 'Deprovision Complete!'",

      "cat /tmp/deprovision.log",

      "echo '========================================='",

    ]
 
    connection {

      type        = "ssh"

      host        = data.azurerm_public_ip.vm_pip.ip_address

      user        = var.admin_username

      private_key = file(var.ssh_private_key_path)

      timeout     = "5m"

    }

  }

}
 
# ─────────────────────────────────────────

# STEP 2 — Deallocate + Generalize VM

# ─────────────────────────────────────────

resource "null_resource" "generalize_vm" {

  depends_on = [null_resource.deprovision_vm]
 
  triggers = {

    deprovision_id = null_resource.deprovision_vm.id

  }
 
  provisioner "local-exec" {

    command = <<EOT

      echo "========================================="

      echo "STEP 2: Starting Deallocation..."

      echo "Timestamp: $(date)"

      echo "========================================="
 
      # Deallocate VM

      az vm deallocate \

        --resource-group ${var.resource_group_name} \

        --name ${var.vm_name}
 
      echo "-----------------------------------------"

      echo "Waiting for VM to fully deallocate..."

      az vm wait \

        --resource-group ${var.resource_group_name} \

        --name ${var.vm_name} \

        --custom "instanceView.statuses[?code=='PowerState/deallocated']" \

        --interval 10 \

        --timeout 300
 
      # ✅ Verify deallocation

      POWER_STATE=$(az vm show \

        --resource-group ${var.resource_group_name} \

        --name ${var.vm_name} \

        --show-details \

        --query "powerState" \

        --output tsv)

      echo "VM Power State: $POWER_STATE"
 
      echo "-----------------------------------------"

      echo "STEP 3: Starting Generalization..."
 
      # Generalize VM

      az vm generalize \

        --resource-group ${var.resource_group_name} \

        --name ${var.vm_name}
 
      # ✅ Verify generalization

      OS_STATE=$(az vm get-instance-view \

        --resource-group ${var.resource_group_name} \

        --name ${var.vm_name} \

        --query "instanceView.statuses[?starts_with(code,'OSState')].displayStatus" \

        --output tsv)

      echo "VM OS State: $OS_STATE"
 
      # ✅ Fail if not generalized

      if [[ "$OS_STATE" != *"Generalized"* ]]; then

        echo "ERROR: Generalization FAILED!"

        exit 1

      fi
 
      echo "========================================="

      echo "Generalization SUCCESSFUL ✅"

      echo "VM is ready for image capture"

      echo "========================================="

    EOT

    interpreter = ["bash", "-c"]

  }

}
 
# ─────────────────────────────────────────

# STEP 3 — Capture Golden Image

# ─────────────────────────────────────────

resource "azurerm_image" "golden_image" {

  depends_on          = [null_resource.generalize_vm]

  name                = "linuxGoldenImage"

  location            = var.location

  resource_group_name = var.resource_group_name
 
  source_virtual_machine_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Compute/virtualMachines/${var.vm_name}"
 
  tags = {

    CreatedBy = "Terraform"

    Purpose   = "GoldenImage"

  }

}
 

resource "azurerm_shared_image_gallery" "sig" {
  name                = "linuxSig"
  resource_group_name = var.resource_group_name
  location            = var.location
  description         = "Shared images for organization"

  lifecycle {
    ignore_changes = [description]
  }
}
resource "azurerm_shared_image" "sig_image" {
  name                = "linuxGoldenImageDef"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"

  identifier {
    publisher = "mycompany"
    offer     = "linuxVM"
    sku       = "rhel9"
  }
}
resource "azurerm_shared_image_version" "sig_version" {
  name                = "1.0.0"
  gallery_name        = azurerm_shared_image_gallery.sig.name
  image_name          = azurerm_shared_image.sig_image.name
  resource_group_name = var.resource_group_name
  location            = var.location
  managed_image_id    = azurerm_image.golden_image.id

  target_region {
    name                  = var.location
    regional_replica_count = 1
    storage_account_type   = "Standard_LRS"
  }
}
data "azurerm_subnet" "existing" {
  name                 = "linux-subnet"
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}

resource "azurerm_network_interface" "new_vm_nic" {
  name                = "${var.new_vm_name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.existing.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "new_vm" {
  name                  = var.new_vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.new_vm_nic.id]
  admin_username        = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }

  # Deploy from Shared Image Version
  source_image_id = azurerm_shared_image_version.sig_version.id
}
