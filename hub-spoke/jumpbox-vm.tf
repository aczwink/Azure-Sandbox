resource "azurerm_linux_virtual_machine" "jumpboxVM" {
    location = var.location
    name = "sbx-vm-${local.appName}-jumpbox"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.jumpboxNIC.id ]
    size = "Standard_B2ats_v2"

    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "sbx-osdisk-${local.appName}-jumpbox"

        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        offer = "0001-com-ubuntu-server-jammy"
        publisher = "Canonical"
        sku = "22_04-lts"
        version = "latest"
    }
}

resource "azurerm_network_interface" "jumpboxNIC" {
    location = var.location
    name = "sbx-nic-${local.appName}-jumpbox"
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"

        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.hubSubnet.id
        public_ip_address_id = azurerm_public_ip.pip.id
    }
}