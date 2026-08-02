resource "azurerm_linux_virtual_machine" "workerNode1" {
    location = var.location
    name = "sbx-vm-${local.appName}-w1"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    custom_data = base64encode(
        templatefile("${path.module}/cloud-init.yaml", {
        })
    )
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.worker1nic.id ]
    size = "Standard_B2als_v2"

    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "sbx-osdisk-${local.appName}-w1"

        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        offer = "ubuntu-26_04-lts"
        publisher = "Canonical"
        sku = "server"
        version = "latest"
    }
}

resource "azurerm_network_interface" "worker1nic" {
    location = var.location
    name = "sbx-nic-${local.appName}-w1"
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"

        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.subnet.id
    }
}