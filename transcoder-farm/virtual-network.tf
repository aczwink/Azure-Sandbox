resource "azurerm_virtual_network" "vnet" {
    location = var.location
    name = "sbx-vnet-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_space = [ "10.0.0.0/16" ]
}

resource "azurerm_subnet" "subnet" {
    name = "sbx-snet-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name

    address_prefixes = [ "10.0.1.0/24" ]
}

resource "azurerm_subnet_network_security_group_association" "nsgAssociaation" {
    network_security_group_id = azurerm_network_security_group.nsg.id
    subnet_id = azurerm_subnet.subnet.id
}