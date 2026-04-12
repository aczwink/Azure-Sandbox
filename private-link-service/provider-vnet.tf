resource "azurerm_virtual_network" "providerVNet" {
    location = var.location
    name = "sbx-vnet-${local.appName}-provider"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.1.0.0/16" ]
}

resource "azurerm_subnet" "serviceSubnet" {
    name = "sbx-snet-${local.appName}-service"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.providerVNet.name

    address_prefixes = [ "10.1.1.0/24" ]
}

resource "azurerm_subnet" "plsSubnet" {
    name = "sbx-snet-${local.appName}-pls"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.providerVNet.name

    address_prefixes = [ "10.1.2.0/24" ]
    private_link_service_network_policies_enabled = false
}

resource "azurerm_subnet_network_security_group_association" "nsgAssociaation" {
    network_security_group_id = azurerm_network_security_group.nsg.id
    subnet_id = azurerm_subnet.serviceSubnet.id
}