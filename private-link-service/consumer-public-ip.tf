resource "azurerm_public_ip" "consumerPIP" {
    location = azurerm_resource_group.rg.location
    name = "sbx-pip-${local.appName}-consumer"
    resource_group_name = azurerm_resource_group.rg.name
    
    allocation_method = "Static"
}