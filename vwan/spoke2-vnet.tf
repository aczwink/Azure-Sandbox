resource "azurerm_virtual_network" "spoke2VNet" {
    location = var.location
    name = "sbx-vnet-${local.appName}2"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.2.0.0/16" ]
}

resource "azurerm_virtual_hub_connection" "spoke2VHubConnection" {
    name = "spoke2-to-vhub-connection"

    remote_virtual_network_id = azurerm_virtual_network.spoke2VNet.id
    virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
}

resource "azurerm_subnet" "spoke2Subnet" {
    name = "sbx-snet-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_prefixes = [ "10.2.0.0/24" ]
    virtual_network_name = azurerm_virtual_network.spoke2VNet.name
}