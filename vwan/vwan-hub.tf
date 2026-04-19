resource "azurerm_virtual_hub" "vwan_hub" {
    location = var.location
    name = "sbx-vhub-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    address_prefix = "10.0.0.0/24"
    sku = "Standard"
    virtual_wan_id = azurerm_virtual_wan.vwan.id
}