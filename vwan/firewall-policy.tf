resource "azurerm_firewall_policy" "firewallPolicy" {
    location = var.location
    name = "sbx-afwp-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    base_policy_id = azurerm_firewall_policy.globalFirewallPolicy.id
}

resource "azurerm_firewall_policy_rule_collection_group" "allowInternalRuleSet" {
    name = "allow-internal"
    firewall_policy_id = azurerm_firewall_policy.firewallPolicy.id

    priority = 1000

    network_rule_collection {
        name = "allow-internal"

        action = "Allow"
        priority = 1000

        rule {
            name = "allow-rdp-to-spoke1"

            destination_addresses = [
                azurerm_windows_virtual_machine.spoke1VM.private_ip_address
            ]
            destination_ports = ["3389"]
            protocols = [ "TCP" ]
            source_addresses = [
                local.vpnAdressSpace
            ]
        }

        rule {
            name = "allow-http-to-spokes"

            destination_addresses = [
                azurerm_linux_virtual_machine.spoke2VM.private_ip_address,
                azurerm_linux_virtual_machine.spoke3VM.private_ip_address
            ]
            destination_ports = ["80"]
            protocols = [ "TCP" ]
            source_addresses = concat([
                local.vpnAdressSpace
            ], tolist(azurerm_virtual_network.spoke1VNet.address_space))
        }
    }
}