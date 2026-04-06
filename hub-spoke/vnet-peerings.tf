resource "azurerm_virtual_network_peering" "hubToSpoke1" {
    name = "peer-hub-to-spoke1"
    remote_virtual_network_id = azurerm_virtual_network.spokeVnet1.id
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub_vnet.name

    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "spoke1ToHub" {
    name = "peer-spoke1-to-hub"
    remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spokeVnet1.name

    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "hubToSpoke2" {
    name = "peer-hub-to-spoke2"
    remote_virtual_network_id = azurerm_virtual_network.spokeVnet2.id
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.hub_vnet.name

    allow_forwarded_traffic = true
}

resource "azurerm_virtual_network_peering" "spoke2ToHub" {
    name = "peer-spoke2-to-hub"
    remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spokeVnet2.name

    allow_forwarded_traffic = true
}