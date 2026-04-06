resource "azurerm_firewall" "hubFirewall" {
    location = var.location
    name = "sbx-afw-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    sku_name = "AZFW_VNet"
    sku_tier = "Standard"

    ip_configuration {
        name = "fw-ipconfig"

        public_ip_address_id = azurerm_public_ip.firewallPip.id
        subnet_id = azurerm_subnet.firewallSubnet.id
    }
}

resource "azurerm_public_ip" "firewallPip" {
    location = var.location
    name = "sbx-pip-${local.appName}-azfw"
    resource_group_name = azurerm_resource_group.rg.name

    allocation_method = "Static"
}

resource "azurerm_firewall_network_rule_collection" "allowJumpboxSSH" {
    name = "allow-jumpbox-ssh"
    resource_group_name = azurerm_resource_group.rg.name

    action = "Allow"
    azure_firewall_name = azurerm_firewall.hubFirewall.name
    priority = 1000

    rule {
        name = "allow-ssh-jumpbox-to-spokes"

        destination_addresses = [
            azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
            azurerm_linux_virtual_machine.spoke2VM.private_ip_address
        ]
        destination_ports = [ "22" ]
        protocols = [ "TCP" ]
        source_addresses = [
            azurerm_linux_virtual_machine.jumpboxVM.private_ip_address
        ]
    }
}

resource "azurerm_firewall_network_rule_collection" "allowSpokesPing" {
    name = "allow-ping-to-spoke-vms"
    resource_group_name = azurerm_resource_group.rg.name

    action = "Allow"
    azure_firewall_name = azurerm_firewall.hubFirewall.name
    priority = 1001

    rule {
        name = "allow-ping-to-spoke-vms"

        destination_addresses = [
            azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
            azurerm_linux_virtual_machine.spoke2VM.private_ip_address
        ]
        destination_ports = ["*"]
        protocols = [ "ICMP" ]
        source_addresses = [
            azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
            azurerm_linux_virtual_machine.spoke2VM.private_ip_address,
            azurerm_linux_virtual_machine.jumpboxVM.private_ip_address
        ]
    }
}

resource "azurerm_firewall_application_rule_collection" "allowInternetHTTPS" {
    name = "allow-https-internet"
    resource_group_name = azurerm_resource_group.rg.name

    action = "Allow"
    azure_firewall_name = azurerm_firewall.hubFirewall.name
    priority = 1000

    rule {
        name = "allow-https-azure"

        target_fqdns = [ 
            "*.azure.com",
            "*.azurefd.net",
            "*.p-msedge.net",
            "*.trafficmanager.net"
        ]
        source_addresses = [
            azurerm_linux_virtual_machine.spoke1VM.private_ip_address,
            azurerm_linux_virtual_machine.spoke2VM.private_ip_address,
        ]

        protocol {
            port = 443
            type = "Https"
        }
    }
}