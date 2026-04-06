resource "azurerm_public_ip" "pip" {
    location = var.location
    name = "sbx-pip-${local.appName}-jumpbox"
    resource_group_name = azurerm_resource_group.rg.name

    allocation_method = "Static"
}