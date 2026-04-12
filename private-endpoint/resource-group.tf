resource "azurerm_resource_group" "rg" {
    location = var.location
    name = "sbx-rg-${local.appName}"
}