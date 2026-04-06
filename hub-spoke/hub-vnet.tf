resource "azurerm_virtual_network" "hub_vnet" {
    location = var.location
    name = "sbx-vnet-${local.appName}-hub"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "hubSubnet" {
    name = "sbx-snet-${local.appName}-hub"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub_vnet.name

    address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_network_security_group" "hubSubnetNSG" {
    location = var.location
    name = "sbx-nsg-${local.appName}-hub"
    resource_group_name = azurerm_resource_group.rg.name

    security_rule = [ 
        {
            access = "Allow"
            description = "Allow SSH inbound from Internet"
            destination_address_prefix = "*"
            destination_address_prefixes = []
            destination_application_security_group_ids = []
            destination_port_range = "22"
            destination_port_ranges = []
            direction = "Inbound"
            name = "allow-ssh-internet"
            priority = 1000
            protocol = "Tcp"
            source_address_prefix = "Internet"
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
            description = "Allow ping to spoke VMs"
            destination_address_prefix = ""
            destination_address_prefixes = [
                azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
                azurerm_linux_virtual_machine.spoke2VM.private_ip_address
            ]
            destination_application_security_group_ids = []
            destination_port_range = "*"
            destination_port_ranges = []
            direction = "Outbound"
            name = "allow-ping-spoke-vms"
            priority = 1000
            protocol = "Icmp"
            source_address_prefix = azurerm_linux_virtual_machine.jumpboxVM.private_ip_address
            source_address_prefixes = []
            source_application_security_group_ids = []
            source_port_range = "*"
            source_port_ranges = []
        },
        {
            access = "Allow"
            description = "Allow SSH to spoke VMs"
            destination_address_prefix = ""
            destination_address_prefixes = [
                azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
                azurerm_linux_virtual_machine.spoke2VM.private_ip_address
            ]
            destination_application_security_group_ids = []
            destination_port_range = "22"
            destination_port_ranges = []
            direction = "Outbound"
            name = "allow-ssh-spoke-vms"
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

resource "azurerm_subnet_network_security_group_association" "nsgAssociaation" {
    network_security_group_id = azurerm_network_security_group.hubSubnetNSG.id
    subnet_id = azurerm_subnet.hubSubnet.id
}

resource "azurerm_subnet" "firewallSubnet" {
    name = "AzureFirewallSubnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub_vnet.name

    address_prefixes = [ "10.0.2.0/24" ]
}