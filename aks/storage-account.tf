resource "azurerm_storage_account" "appFilesStorage" {
    location = var.location
    name = "sbxst${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    account_replication_type = "LRS"
    account_tier = "Standard"
}

resource "azurerm_storage_share" "appFilesShare" {
    name = "app-files"
    storage_account_id = azurerm_storage_account.appFilesStorage.id

    quota = 1
}