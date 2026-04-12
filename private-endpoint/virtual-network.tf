resource "azurerm_virtual_network" "vnet" {
    location = var.location
    name = "sbx-vnet-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetDNSZoneLink" {
    name = "privatelink-storage-blob-dns-zone-link"
    resource_group_name = azurerm_resource_group.rg.name

    private_dns_zone_name = azurerm_private_dns_zone.privateStorageBlobDNSZone.name
    virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_subnet" "vmSubnet" {
    name = "sbx-snet-${local.appName}-vm"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name

    address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_subnet_network_security_group_association" "vmSubnet_nsg_association" {
    network_security_group_id = azurerm_network_security_group.nsg.id
    subnet_id = azurerm_subnet.vmSubnet.id
}

resource "azurerm_subnet" "privateEndpointSubnet" {
    name = "sbx-snet-${local.appName}-pe"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name

    address_prefixes = [ "10.0.2.0/24" ]
}