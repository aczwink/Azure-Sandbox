resource "azurerm_private_link_service" "pls" {
    location = var.location
    name = "sbx-pl-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    load_balancer_frontend_ip_configuration_ids = [
        azurerm_lb.lb.frontend_ip_configuration[0].id
    ]

    nat_ip_configuration {
        name = "pls-nat-ip"

        primary = true
        subnet_id = azurerm_subnet.plsSubnet.id
    }
}