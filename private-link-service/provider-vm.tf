resource "azurerm_network_interface" "providerNIC" {
    location = var.location
    name = "sbx-nic-${local.appName}-provider"
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"

        private_ip_address_allocation = "Dynamic"
        subnet_id = azurerm_subnet.serviceSubnet.id
    }
}

resource "azurerm_linux_virtual_machine" "providerVM" {
    location = var.location
    name = "sbx-vm-${local.appName}-provider"
    resource_group_name = azurerm_resource_group.rg.name

    admin_password = "UseKeyVault1234!"
    admin_username = "azureuser"
    custom_data = base64encode(<<-CUSTOM_DATA
#cloud-config
package_update: true
packages:
  - nginx

runcmd:
  - systemctl enable nginx
  - systemctl start nginx
  - echo "Hello from Private Link Service!" > /var/www/html/index.html
CUSTOM_DATA
    )
    disable_password_authentication = false
    network_interface_ids = [ azurerm_network_interface.providerNIC.id ]
    size = "Standard_B2ats_v2"

    identity {
        type = "SystemAssigned"
    }

    os_disk {
        name = "sbx-osdisk-${local.appName}-provider"

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