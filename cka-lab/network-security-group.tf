resource "azurerm_network_security_group" "nsg" {
    location = var.location
    name = "sbx-nsg-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    security_rule = [
        {
            access = "Allow"
            description = "Allow SSH inbound to control plane from internet"
            destination_address_prefix = ""
            destination_address_prefixes = azurerm_subnet.subnet.address_prefixes
            destination_application_security_group_ids = []
            destination_port_range = "22"
            destination_port_ranges = []
            direction = "Inbound"
            name = "allow-ssh-cp1"
            priority = 1000
            protocol = "Tcp"
            source_address_prefix = "Internet"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Allow"
            description = "Allow inbound within vnet"
            destination_address_prefix = ""
            destination_address_prefixes = azurerm_subnet.subnet.address_prefixes
            destination_application_security_group_ids = []
            destination_port_range = "*"
            destination_port_ranges = []
            direction = "Inbound"
            name = "allow-vnet-inbound"
            priority = 1001
            protocol = "Tcp"
            source_address_prefix = ""
            source_address_prefixes = azurerm_subnet.subnet.address_prefixes
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Deny"
            description = "Deny inbound"
            destination_address_prefix = "*"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "*"
            destination_port_ranges = []
            direction = "Inbound"
            name = "deny-inbound"
            priority = 4096
            protocol = "*"
            source_address_prefix = "*"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },

        //outbound
        {
            access = "Allow"
            description = "Allow http to internet"
            destination_address_prefix = "Internet"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "80"
            destination_port_ranges = []
            direction = "Outbound"
            name = "allow-http-outbound"
            priority = 1000
            protocol = "Tcp"
            source_address_prefix = "*"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Allow"
            description = "Allow https to internet"
            destination_address_prefix = "Internet"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "443"
            destination_port_ranges = []
            direction = "Outbound"
            name = "allow-https-outbound"
            priority = 1001
            protocol = "Tcp"
            source_address_prefix = "*"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Allow"
            description = "Allow outbound to vnet"
            destination_address_prefix = ""
            destination_address_prefixes = azurerm_subnet.subnet.address_prefixes
            destination_application_security_group_ids = []
            destination_port_range = "*"
            destination_port_ranges = []
            direction = "Outbound"
            name = "allow-vnet-outbound"
            priority = 1002
            protocol = "Tcp"
            source_address_prefix = ""
            source_address_prefixes = azurerm_subnet.subnet.address_prefixes
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Deny"
            description = "Deny outbound"
            destination_address_prefix = "*"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "*"
            destination_port_ranges = []
            direction = "Outbound"
            name = "deny-outbound"
            priority = 4096
            protocol = "*"
            source_address_prefix = "*"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        }
    ]
}