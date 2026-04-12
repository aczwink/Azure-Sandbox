resource "azurerm_private_dns_zone" "privateStorageBlobDNSZone" {
    name = "privatelink.blob.core.windows.net"
    resource_group_name = azurerm_resource_group.rg.name
}