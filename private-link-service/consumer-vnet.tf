resource "azurerm_virtual_network" "consumerVNet" {
    location = var.location
    name = "sbx-vnet-${local.appName}-consumer"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.2.0.0/16" ]
}

resource "azurerm_subnet" "clientSubnet" {
    name = "sbx-snet-${local.appName}-client"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.consumerVNet.name

    address_prefixes = [ "10.2.1.0/24" ]
}

resource "azurerm_subnet" "peSubnet" {
    name = "sbx-snet-${local.appName}-pe"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.consumerVNet.name

    address_prefixes = [ "10.2.2.0/24" ]
}

resource "azurerm_subnet_network_security_group_association" "consumerClientNSG_assoc" {
    network_security_group_id = azurerm_network_security_group.consumerNSG.id
    subnet_id = azurerm_subnet.clientSubnet.id
}