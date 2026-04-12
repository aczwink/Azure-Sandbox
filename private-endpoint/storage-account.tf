resource "random_string" "suffix" {
    length  = 10
    upper   = false
    special = false
}

resource "azurerm_storage_account" "storageAccount" {
    location = var.location
    name = "sbxst${local.appName}${random_string.suffix.result}"
    resource_group_name = azurerm_resource_group.rg.name

    account_replication_type = "LRS"
    account_tier = "Standard"
    public_network_access_enabled = false
}

resource "azurerm_storage_container" "testContainer" {
    name = "test-container"

    storage_account_id = azurerm_storage_account.storageAccount.id
}