resource "azurerm_private_endpoint" "privateEndpoint" {
    location = var.location
    name = "sbx-pep-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name
    subnet_id = azurerm_subnet.peSubnet.id

    private_service_connection {
        name = "psc-to-pls"

        is_manual_connection = true
        private_connection_resource_id = azurerm_private_link_service.pls.id
        request_message = "Approve me in the portal please :)"
    }
}