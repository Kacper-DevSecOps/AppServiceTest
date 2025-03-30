variable "location" {
  type        = string
  description = "Azure Region"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "vnet_address_space" {
  type        = list(string)
}

variable "db_subnet_prefix" {
  type        = list(string)
}

variable "web_subnet_prefix" {
  type        = list(string)
}

variable "postgresql_sku_name" {
  type        = string
}

variable "postgresql_storage_mb" {
  type        = number
}

variable "postgresql_version" {
  type        = string
}

variable "postgresql_admin_username" {
  type        = string
}

variable "postgresql_admin_password" {
  type        = string
}

variable "app_service_plan_sku_name" {
  type        = string
}

variable "python_version" {
  type        = string
}
