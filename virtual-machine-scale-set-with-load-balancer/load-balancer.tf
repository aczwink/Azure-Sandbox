resource "azurerm_lb" "lb" {
    location = var.location
    name = "sbx-lbe-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    frontend_ip_configuration {
        name = "PublicIPAddress"
        public_ip_address_id = azurerm_public_ip.pip.id
    }
}

resource "azurerm_lb_backend_address_pool" "pool" {
    name = "vmss-pool"

    loadbalancer_id = azurerm_lb.lb.id
}
resource "azurerm_lb_probe" "probe" {
    name = "http-probe"

    loadbalancer_id = azurerm_lb.lb.id
    port = 80
}

resource "azurerm_lb_rule" "rule" {
    name = "http-rule"

    backend_address_pool_ids = [ azurerm_lb_backend_address_pool.pool.id ]
    backend_port = 80
    frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
    frontend_port = 80
    loadbalancer_id = azurerm_lb.lb.id
    probe_id = azurerm_lb_probe.probe.id
    protocol = "Tcp"
}