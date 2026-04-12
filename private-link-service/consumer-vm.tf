resource "azurerm_network_interface" "consumerNIC" {
    location = var.location
    name = "sbx-nic-${local.appName}-consumer"
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"

        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.consumerPIP.id
        subnet_id = azurerm_subnet.clientSubnet.id
    }
}

resource "azurerm_windows_virtual_machine" "consumerVM" {
    location = var.location
    name = "sbx-vm-${local.appName}c"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    network_interface_ids = [ azurerm_network_interface.consumerNIC.id ]
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