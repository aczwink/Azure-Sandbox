resource "azurerm_network_security_group" "nsg" {
    location = var.location
    name = "sbx-nsg-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    security_rule = []
}