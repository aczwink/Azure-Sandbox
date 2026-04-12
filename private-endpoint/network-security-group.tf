resource "azurerm_network_security_group" "nsg" {
    location = azurerm_resource_group.rg.location
    name = "sbx-nsg-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name
    
    security_rule = [
        {
            access = "Allow"
            description = "Allow RDP access"
            destination_address_prefix = azurerm_network_interface.nic.private_ip_address
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "3389"
            destination_port_ranges = []
            direction = "Inbound"
            name = "allow-rdp"
            priority = 1001
            protocol = "Tcp"
            source_address_prefix = "*"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        }
    ]
}