resource "azurerm_virtual_network" "spokeVnet1" {
    location = var.location
    name = "sbx-vnet-${local.appName}-spoke1"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.1.0.0/16" ]
}

resource "azurerm_subnet" "spoke1Subnet" {
    name = "sbx-snet-${local.appName}-spoke1"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.spokeVnet1.name

    address_prefixes = [ "10.1.1.0/24" ]
}

resource "azurerm_subnet_network_security_group_association" "nsgAssociaationSpoke1" {
    network_security_group_id = azurerm_network_security_group.spokeSubnetNSG.id
    subnet_id = azurerm_subnet.spoke1Subnet.id
}

resource "azurerm_subnet_route_table_association" "spoke1SubnetRouteTableAssoc" {
    route_table_id = azurerm_route_table.spokesRouteTable.id
    subnet_id = azurerm_subnet.spoke1Subnet.id
}