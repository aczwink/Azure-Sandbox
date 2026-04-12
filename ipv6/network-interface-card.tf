resource "azurerm_network_interface" "nic" {
    location = var.location
    name = "sbx-nic-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "internal"

        primary = true
        private_ip_address_allocation = "Dynamic"
        private_ip_address_version = "IPv4"
        subnet_id = azurerm_subnet.subnet.id
    }

    ip_configuration {
        name = "ipv6-config"

        private_ip_address_allocation = "Dynamic"
        private_ip_address_version = "IPv6"
        public_ip_address_id = azurerm_public_ip.pip.id
        subnet_id = azurerm_subnet.subnet.id
    }
}