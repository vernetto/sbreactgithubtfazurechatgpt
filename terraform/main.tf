terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Explicit subscription_id avoids the "subscription_id is required" error.
  subscription_id = var.subscription_id
}

#####################
# Variables
#####################

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID to deploy into"
}

variable "location" {
  type        = string
  description = "Azure region"
  default     = "switzerlandnorth"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
  default     = "rg-hello-react-spring"
}

variable "app_service_plan_name" {
  type        = string
  description = "App Service Plan name"
  default     = "asp-hello-react-spring"
}

variable "app_name" {
  type        = string
  description = "Azure Web App name"
  default     = "hello-react-spring-app"
}

variable "acr_name" {
  type        = string
  description = "Azure Container Registry name (must be globally unique, lowercase)"
  default     = "helloreactspringacr"
}

variable "docker_image_name" {
  type        = string
  description = "Name part of the Docker image (without registry and tag)"
  default     = "hello-react-spring"
}

variable "docker_image_tag" {
  type        = string
  description = "Docker image tag to deploy"
  default     = "latest"
}

#####################
# Resources
#####################

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  os_type  = "Linux"
  sku_name = "B1" # pick S1/P1V3/etc. for production
}

resource "azurerm_linux_web_app" "app" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.plan.id
  https_only          = true

  site_config {
    always_on = true

    application_stack {
      # e.g. myacr.azurecr.io/hello-react-spring:latest
      docker_image_name   = "${azurerm_container_registry.acr.login_server}/${var.docker_image_name}:${var.docker_image_tag}"
      docker_registry_url = "https://${azurerm_container_registry.acr.login_server}"
    }
  }

  app_settings = {
    # Web App will listen on this port inside the container
    "WEBSITES_PORT" = "8080"
  }
}

#####################
# Outputs
#####################

output "app_name" {
  value = azurerm_linux_web_app.app.name
}

output "app_default_hostname" {
  value = azurerm_linux_web_app.app.default_hostname
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value     = azurerm_container_registry.acr.admin_password
  sensitive = true
}
