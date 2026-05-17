resource "azurerm_kubernetes_cluster" "aks" {
    location = var.location
    name = "sbx-aks-${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    dns_prefix = local.appName
    node_resource_group = "sbx-aks-${local.appName}-AZURE"
    oidc_issuer_enabled = true
    sku_tier = "Free"
    
    default_node_pool {
        name = "default"

        node_count = 1
        vm_size = "Standard_B2als_v2"

        upgrade_settings {
            max_surge = "10%"
        }
    }

    identity {
        type = "SystemAssigned"
    }
}

/*
resource "azurerm_kubernetes_cluster_node_pool" "userNodePool" {
    name = "workloads"

    kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
    mode = "User"
    node_count = 3
    vm_size = "Standard_B2als_v2"

    upgrade_settings {
    }
}
*/

resource "azurerm_kubernetes_cluster_node_pool" "spotPool" {
    name = "spot"

    auto_scaling_enabled = true
    eviction_policy = "Delete"
    kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
    max_count = 3
    min_count = 0
    mode = "User"
    node_taints = [
        "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
    ]
    priority = "Spot"
    spot_max_price = -1
    vm_size = "Standard_B2als_v2"
}