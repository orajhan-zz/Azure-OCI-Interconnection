# Create Public IP for VM
resource "azurerm_public_ip" "VM-publicIP" {
  name                    = "${var.prefix}-VM-pip"
  location                = azurerm_resource_group.AzureRG.location
  resource_group_name     = azurerm_resource_group.AzureRG.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
}

# Create network interface for VM
resource "azurerm_network_interface" "VMnic" {
  name                = "${var.prefix}-nic"
  resource_group_name = azurerm_resource_group.AzureRG.name
  location            = azurerm_resource_group.AzureRG.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.VMnetwork.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.VM-publicIP.id
  }
}

# Create a small VM for connectivity test
resource "azurerm_linux_virtual_machine" "testVM" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = azurerm_resource_group.AzureRG.name
  location                        = azurerm_resource_group.AzureRG.location
  size                            = var.shape
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.VMnic.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

