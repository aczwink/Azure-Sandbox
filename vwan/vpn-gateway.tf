resource "azurerm_point_to_site_vpn_gateway" "vpnGateway" {
    location = var.location
    name = "sbx-vpng-${local.appName}-p2s"
    resource_group_name = azurerm_resource_group.rg.name

    scale_unit = 1
    virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
    vpn_server_configuration_id = azurerm_vpn_server_configuration.vpnServerConfig.id

    connection_configuration {
        name = "p2s-config"

        vpn_client_address_pool {
            address_prefixes = [ local.vpnAdressSpace ]
        }
    }
}