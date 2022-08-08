data "azurerm_shared_image" "search" {
  name                = "powergate-image-definition"
  resource_group_name = "bridgez"
  gallery_name        = "powergate"
}



resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = "East US"
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_security_group" "example" {
  name                = "ipfs-sg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name              = "SSH"
    priority          = 1001
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    //destination_port_ranges    = var.inbound_port_ranges
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = "East US"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}


resource "azurerm_public_ip" "example" {
  name                = "ipfs-vm-public-ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"

  tags = {
    environment = "Terraform Demo"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}




resource "azurerm_linux_virtual_machine" "example" {
  name                = "ipfs-machine"
  location            = "East US"
  resource_group_name = var.resource_group_name
  size                = "Standard_F2"
  admin_username      = "adminuser"
  # source_image_id     = data.azurerm_shared_image.search.id
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  identity {
    type = "SystemAssigned"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("./keys/key.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = filebase64("./scripts/script.sh")


}
