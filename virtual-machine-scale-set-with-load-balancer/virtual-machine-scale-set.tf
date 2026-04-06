resource "azurerm_orchestrated_virtual_machine_scale_set" "vmss" {
    location = var.location
    name = "sbx-vmss-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    instances = 2
    platform_fault_domain_count = 1
    sku_name = "Standard_B2ats_v2"

    network_interface {
        name = "sbx-nic-${local.appName}"

        ip_configuration {
            name = "internal"
            subnet_id = azurerm_subnet.subnet.id

            load_balancer_backend_address_pool_ids = [ azurerm_lb_backend_address_pool.pool.id ]
        }
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    os_profile {
        custom_data = base64encode(<<CUSTOM_DATA
#!/bin/bash
sudo -i
apt update
apt install -y nginx
systemctl enable nginx
systemctl start nginx
echo "Hello from VMSS $(hostname)" > /var/www/html/index.html
EOF
CUSTOM_DATA
        )

        linux_configuration {
            admin_password = "UseKeyVault1234!"
            admin_username = "azureuser"
            disable_password_authentication = false
        }
    }

    source_image_reference {
        offer = "0001-com-ubuntu-server-jammy"
        publisher = "Canonical"
        sku = "22_04-lts"
        version = "latest"
    }
}