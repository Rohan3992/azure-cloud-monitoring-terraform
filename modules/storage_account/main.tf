variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing Resource Group"
  type        = string
}

variable "location" {
  description = "Azure region for the Storage Account"
  type        = string
}

resource "azurerm_storage_account" "this" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false

  tags = {
    environment = "learning"
    project     = "terraform-cloud-infrastructure"
  }
}

output "name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.this.name
}

output "location" {
  description = "Storage Account location"
  value       = azurerm_storage_account.this.location
}
