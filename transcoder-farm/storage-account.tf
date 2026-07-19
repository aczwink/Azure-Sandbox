resource "azurerm_storage_account" "storageAccount" {
    location = var.location
    name = "sbxst${local.appName}"
    resource_group_name = azurerm_resource_group.rg.name

    account_replication_type = "LRS"
    account_tier = "Standard"
}

resource "azurerm_storage_container" "inputh264container" {
    name = "input-h264"
    storage_account_id = azurerm_storage_account.storageAccount.id
}

resource "azurerm_storage_container" "inputh265container" {
    name = "input-h265"
    storage_account_id = azurerm_storage_account.storageAccount.id
}

resource "azurerm_storage_container" "outputContainer" {
    name = "output"
    storage_account_id = azurerm_storage_account.storageAccount.id
}