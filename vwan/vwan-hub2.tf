resource "azurerm_virtual_hub" "vwan_hub2" {
    location = var.location2
    name = "sbx-vhub-${local.appName}2"
    resource_group_name = azurerm_resource_group.rg.name

    address_prefix = "10.0.1.0/24"
    sku = "Standard"
    virtual_wan_id = azurerm_virtual_wan.vwan.id
}