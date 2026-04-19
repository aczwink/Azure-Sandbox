resource "azurerm_vpn_server_configuration" "vpnServerConfig" {
    location = var.location
    name = "vpn-config"
    resource_group_name = azurerm_resource_group.rg.name

    vpn_authentication_types = ["Certificate"]

    client_root_certificate {
        name = "root-cert"
        public_cert_data = filebase64("certs/rootcert.cer")
    }
}