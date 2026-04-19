resource "azurerm_firewall" "vwanFirewll" {
    location = var.location
    name = "sbx-afw-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    firewall_policy_id = azurerm_firewall_policy.firewallPolicy.id
    sku_name = "AZFW_Hub"
    sku_tier = "Standard"

    virtual_hub {
        virtual_hub_id = azurerm_virtual_hub.vwan_hub.id
    }
}