resource "azurerm_virtual_network" "spokeVnet2" {
    location = var.location
    name = "sbx-vnet-${local.appName}-spoke2"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.2.0.0/16" ]
}

resource "azurerm_subnet" "spoke2Subnet" {
    name = "sbx-snet-${local.appName}-spoke2"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spokeVnet2.name

    address_prefixes = [ "10.2.1.0/24" ]
}

resource "azurerm_subnet_network_security_group_association" "nsgAssociaationSpoke2" {
    network_security_group_id = azurerm_network_security_group.spokeSubnetNSG.id
    subnet_id = azurerm_subnet.spoke2Subnet.id
}

resource "azurerm_subnet_route_table_association" "spoke2SubnetRouteTableAssoc" {
    route_table_id = azurerm_route_table.spokesRouteTable.id
    subnet_id = azurerm_subnet.spoke2Subnet.id
}