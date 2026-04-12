resource "azurerm_windows_virtual_machine" "vm" {
    location = var.location
    name = "sbx-vm-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    network_interface_ids = [ azurerm_network_interface.nic.id ]
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