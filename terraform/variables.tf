variable "location" {
  description = "Azure region (e.g. westeurope, switzerlandnorth)"
  type        = string
  default     = "switzerlandnorth"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
  default     = "rg-hello-react-spring"
}

variable "name_prefix" {
  description = "Prefix used for resource names (must be globally unique for the web app name when combined with '-app')"
  type        = string
  default     = "hello-rs-pv001"
}

variable "app_service_sku" {
  description = "App Service plan SKU"
  type        = string
  default     = "F1"
}
