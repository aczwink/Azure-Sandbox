resource "azurerm_kubernetes_cluster" "aks" {
    location = var.location
    name = "sbx-aks-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    dns_prefix = local.appName
    node_resource_group = "sbx-aks-${local.appName}-AZURE"
    
    default_node_pool {
        name = "default"

        node_count = 1
        vm_size = "Standard_B2als_v2"
    }

    identity {
        type = "SystemAssigned"
    }
}