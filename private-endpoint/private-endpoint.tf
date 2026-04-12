resource "azurerm_private_endpoint" "privateEndpointStorageBlob" {
    location = var.location
    name = "sbx-pep-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name
    subnet_id = azurerm_subnet.privateEndpointSubnet.id

    private_dns_zone_group {
        name = "dns-zone-group"
        private_dns_zone_ids = [ azurerm_private_dns_zone.privateStorageBlobDNSZone.id ]
    }

    private_service_connection {
        name = "psc-storage-blob"

        is_manual_connection = false
        private_connection_resource_id = azurerm_storage_account.storageAccount.id
        subresource_names = [ "blob" ]
    }
}