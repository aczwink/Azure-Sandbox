resource "azurerm_virtual_network" "spoke3VNet" {
    location = var.location2
    name = "sbx-vnet-${local.appName}3"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.3.0.0/16" ]
}

resource "azurerm_virtual_hub_connection" "spoke3VHubConnection" {
    name = "spoke3-to-vhub-connection"

    remote_virtual_network_id = azurerm_virtual_network.spoke3VNet.id
    virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
}

resource "azurerm_subnet" "spoke3Subnet" {
    name = "sbx-snet-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_prefixes = [ "10.3.0.0/24" ]
    virtual_network_name = azurerm_virtual_network.spoke3VNet.name
}