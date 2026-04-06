resource "azurerm_route_table" "spokesRouteTable" {
    location = var.location
    name = "sbx-rt-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_route" "defaultRouteToFirewall" {
    name = "sbx-udr-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_prefix = "0.0.0.0/0"
    next_hop_type = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hubFirewall.ip_configuration[0].private_ip_address
    route_table_name = azurerm_route_table.spokesRouteTable.name
}