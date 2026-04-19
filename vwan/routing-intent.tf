resource "azurerm_virtual_hub_routing_intent" "routingIntent" {
    name = "routing-intent"

    virtual_hub_id = azurerm_virtual_hub.vwan_hub.id

    routing_policy {
        name = "internet-policy"

        destinations = ["Internet"]
        next_hop = azurerm_firewall.vwanFirewll.id
    }

    routing_policy {
        name = "private-policy"

        destinations = ["PrivateTraffic"]
        next_hop = azurerm_firewall.vwanFirewll.id
    }
}