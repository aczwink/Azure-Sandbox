resource "azurerm_firewall_policy" "globalFirewallPolicy" {
    location = var.location
    name = "sbx-afwp-${local.appName}-global"
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_firewall_policy_rule_collection_group" "allowPingInVWANRuleSet" {
    name = "allow-ping-inside-vwan-network"
    firewall_policy_id = azurerm_firewall_policy.globalFirewallPolicy.id

    priority = 1000

    network_rule_collection {
        name = "allow-ping-inside-vwan-network"

        action = "Allow"
        priority = 1000

        rule {
            name = "allow-ping-inside-vwan-network"

            destination_addresses = concat(
                tolist(azurerm_virtual_network.spoke1VNet.address_space),
                tolist(azurerm_virtual_network.spoke2VNet.address_space),
                tolist(azurerm_virtual_network.spoke3VNet.address_space)
            )
            destination_ports = ["*"]
            protocols = [ "ICMP" ]
            source_addresses = concat(
                tolist(azurerm_virtual_network.spoke1VNet.address_space),
                tolist(azurerm_virtual_network.spoke2VNet.address_space),
                tolist(azurerm_virtual_network.spoke3VNet.address_space)
            )
        }
    }
}