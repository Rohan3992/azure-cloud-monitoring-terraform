terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-learning"
    storage_account_name = "stlearn480591ae"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_azuread_auth     = true
    use_cli              = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-terraform-learning"
}

variable "location" {
  description = "Azure region for deployment"
  type        = string
  default     = "Central India"
}

variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name"
  type        = string
}
module "app_monitoring" {
  source = "./modules/app_monitoring"

  app_name            = "rohan-cloud-monitoring-2026"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
}
module "resource_group" {
  source = "./modules/resource_group"

  resource_group_name = var.resource_group_name
  location            = var.location
}

module "storage_account" {
  source = "./modules/storage_account"

  storage_account_name = var.storage_account_name
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
}

moved {
  from = azurerm_resource_group.project
  to   = module.resource_group.azurerm_resource_group.this
}

moved {
  from = azurerm_storage_account.learning
  to   = module.storage_account.azurerm_storage_account.this
}

output "resource_group_name" {
  value = module.resource_group.name
}

output "storage_account_name" {
  value = module.storage_account.name
}

output "storage_account_location" {
  value = module.storage_account.location
}
output "web_app_name" {
  value = module.app_monitoring.web_app_name
}

output "web_app_url" {
  value = module.app_monitoring.web_app_url
}
