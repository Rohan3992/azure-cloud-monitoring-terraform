variable "app_name" {
  description = "Globally unique Linux Web App name"
  type        = string
}

variable "resource_group_name" {
  description = "Existing Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure deployment region"
  type        = string
}

resource "azurerm_service_plan" "learning" {
  name                = "${var.app_name}-plan"
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = "F1"

  tags = {
    environment = "learning"
    project     = "terraform-cloud-infrastructure"
  }
}

resource "azurerm_linux_web_app" "learning" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.learning.id

  https_only = true
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.learning.connection_string
    SCM_DO_BUILD_DURING_DEPLOYMENT        = "true"
  }



  site_config {
    app_command_line = "gunicorn --bind=0.0.0.0:8000 app:app"
    always_on        = false

    application_stack {
      python_version = "3.12"
    }
  }

  tags = {
    environment = "learning"
    project     = "terraform-cloud-infrastructure"
  }
}

output "web_app_name" {
  value = azurerm_linux_web_app.learning.name
}

output "web_app_url" {
  value = "https://${azurerm_linux_web_app.learning.default_hostname}"
}
resource "azurerm_log_analytics_workspace" "learning" {
  name                = "${var.app_name}-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.1

  tags = {
    environment = "learning"
    project     = "terraform-cloud-infrastructure"
  }
}

resource "azurerm_application_insights" "learning" {
  name                = "${var.app_name}-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.learning.id

  tags = {
    environment = "learning"
    project     = "terraform-cloud-infrastructure"
  }
}


output "application_insights_name" {
  value = azurerm_application_insights.learning.name
}

output "log_analytics_workspace_name" {
  value = azurerm_log_analytics_workspace.learning.name
}

