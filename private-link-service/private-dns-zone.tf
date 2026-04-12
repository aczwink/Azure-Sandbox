resource "azurerm_private_dns_zone" "privateDNSZone" {
    name = "pls.demo.internal"
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_a_record" "addressRecord" {
    name = "app"
    resource_group_name = azurerm_resource_group.rg.name
    zone_name = azurerm_private_dns_zone.privateDNSZone.name
    
    records = [
        azurerm_private_endpoint.privateEndpoint.private_service_connection[0].private_ip_address
    ]
    ttl = 300
}

resource "azurerm_private_dns_zone_virtual_network_link" "consumerDNSZoneLink" {
    name = "consumer-zone-dns-zone-link"
    resource_group_name = azurerm_resource_group.rg.name

    private_dns_zone_name = azurerm_private_dns_zone.privateDNSZone.name
    virtual_network_id = azurerm_virtual_network.consumerVNet.id
}