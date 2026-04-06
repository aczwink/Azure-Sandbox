resource "azurerm_network_security_group" "spokeSubnetNSG" {
    location = var.location
    name = "sbx-nsg-${local.appName}-spoke"
    resource_group_name = azurerm_resource_group.rg.name

    security_rule = [ 
        {
            access = "Allow"
            description = "Allow ping inbound from jumpbox"
            destination_address_prefix = "VirtualNetwork"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "*"
            destination_port_ranges = []
            direction = "Inbound"
            name = "allow-ping-jumpbox"
            priority = 1000
            protocol = "Icmp"
            source_address_prefix = ""
            source_address_prefixes = [
                azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
                azurerm_linux_virtual_machine.spoke2VM.private_ip_address
            ]
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Allow"
            description = "Allow SSH inbound from jumpbox"
            destination_address_prefix = "VirtualNetwork"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "22"
            destination_port_ranges = []
            direction = "Inbound"
            name = "allow-ssh-jumpbox"
            priority = 1001
            protocol = "Tcp"
            source_address_prefix = azurerm_linux_virtual_machine.jumpboxVM.private_ip_address
            source_address_prefixes = []
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
            description = "Allow ping to other spokes"
            destination_address_prefix = ""
            destination_address_prefixes = [
                azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
                azurerm_linux_virtual_machine.spoke2VM.private_ip_address
            ]
            destination_application_security_group_ids = []
            destination_port_range = "*"
            destination_port_ranges = []
            direction = "Outbound"
            name = "allow-ping-to-spokes"
            priority = 1000
            protocol = "Icmp"
            source_address_prefix = "VirtualNetwork"
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Allow"
            description = "Allow outbound to internet"
            destination_address_prefix = "Internet"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "443"
            destination_port_ranges = []
            direction = "Outbound"
            name = "allow-outbound-internet"
            priority = 1001
            protocol = "Tcp"
            source_address_prefix = "VirtualNetwork"
            source_address_prefixes = []
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