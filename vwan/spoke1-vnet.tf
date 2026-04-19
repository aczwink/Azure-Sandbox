resource "azurerm_virtual_network" "spoke1VNet" {
    location = var.location
    name = "sbx-vnet-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.1.0.0/16" ]
}

resource "azurerm_virtual_hub_connection" "spoke1VHubConnection" {
    name = "spoke1-to-vhub-connection"

    remote_virtual_network_id = azurerm_virtual_network.spoke1VNet.id
    virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
}

resource "azurerm_subnet" "spoke1Subnet" {
    name = "sbx-snet-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_prefixes = [ "10.1.0.0/24" ]
    virtual_network_name = azurerm_virtual_network.spoke1VNet.name
}