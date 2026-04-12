resource "azurerm_network_security_group" "consumerNSG" {
    location = var.location
    name = "sbx-nsg-${local.appName}-consumer"
    resource_group_name = azurerm_resource_group.rg.name

    security_rule = [ 
        {
            access = "Allow"
            description = "Allow RDP inbound from Internet"
            destination_address_prefix = "*"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "3389"
            destination_port_ranges = []
            direction = "Inbound"
            name = "allow-rdp-internet"
            priority = 1000
            protocol = "Tcp"
            source_address_prefix = "Internet"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        }
     ]
}