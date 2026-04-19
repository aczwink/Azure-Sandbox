resource "azurerm_virtual_wan" "vwan" {
    location = var.location
    name = "sbx-vwan-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    type = "Standard"
}