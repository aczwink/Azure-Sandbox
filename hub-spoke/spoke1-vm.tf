resource "azurerm_linux_virtual_machine" "spoke1VM" {
    location = var.location
    name = "sbx-vm-${local.appName}-spoke1"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.spoke1NIC.id ]
    size = "Standard_B2ats_v2"

    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "sbx-osdisk-${local.appName}-spoke1"

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

resource "azurerm_network_interface" "spoke1NIC" {
    location = var.location
    name = "sbx-nic-${local.appName}-spoke1"
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"

        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.spoke1Subnet.id
    }
}