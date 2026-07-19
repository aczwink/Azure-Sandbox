resource "azurerm_linux_virtual_machine" "transcoderVM" {
    location = var.location
    name = "sbx-vm-${local.appName}-transcoder"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    custom_data = base64encode(
        templatefile("${path.module}/cloud-init.yaml", {
            storage_account_name = azurerm_storage_account.storageAccount.name
        })
    )
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.nic.id ]
    size = "Standard_D4s_v5"


    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "sbx-osdisk-${local.appName}"

        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        offer = "ubuntu-24_04-lts"
        publisher = "Canonical"
        sku = "server"
        version = "latest"
    }
}

resource "azurerm_network_interface" "nic" {
    location = var.location
    name = "sbx-nic-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"

        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.subnet.id
    }
}

resource "azurerm_managed_disk" "workDisk" {
    location = var.location
    name = "sbx-disk-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    create_option = "Empty"
    disk_size_gb = 128
    storage_account_type = "Standard_LRS"
}

resource "azurerm_virtual_machine_data_disk_attachment" "managedDiskAttachment" {
    caching = "ReadWrite"
    lun = 0
    managed_disk_id = azurerm_managed_disk.workDisk.id
    virtual_machine_id = azurerm_linux_virtual_machine.transcoderVM.id
}

resource "azurerm_role_assignment" "transcoderVM_BlobContributorRoleAssignment" {
    principal_id = azurerm_linux_virtual_machine.transcoderVM.identity[0].principal_id
    role_definition_name = "Storage Blob Data Contributor"
    scope = azurerm_storage_account.storageAccount.id
}