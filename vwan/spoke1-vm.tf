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

resource "azurerm_windows_virtual_machine" "spoke1VM" {
    location = var.location
    name = "sbx-vm-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    network_interface_ids = [ azurerm_network_interface.spoke1NIC.id ]
    size = "Standard_B2ats_v2"

    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "sbx-osdisk-${local.appName}"

        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        offer = "WindowsServer"
        publisher = "MicrosoftWindowsServer"
        sku = "2022-Datacenter"
        version = "latest"
    }
}