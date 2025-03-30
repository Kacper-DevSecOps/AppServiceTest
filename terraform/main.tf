resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "db_subnet" {
  name                                           = "db-subnet-${var.environment}"
  resource_group_name                            = azurerm_resource_group.main.name
  virtual_network_name                           = azurerm_virtual_network.vnet.name
  address_prefixes                               = var.db_subnet_prefix

}

resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet-${var.environment}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.web_subnet_prefix
}

resource "random_id" "suffix" {
  byte_length = 3
}

resource "azurerm_postgresql_server" "pgdb" {
  name                          = "pg-${var.environment}-${random_id.suffix.hex}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  sku_name                      = var.postgresql_sku_name
  storage_mb                    = var.postgresql_storage_mb
  version                       = var.postgresql_version
  administrator_login           = var.postgresql_admin_username
  administrator_login_password  = var.postgresql_admin_password
  ssl_enforcement_enabled       = true
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "pgdb_endpoint" {
  name                = "pg-endpoint-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.db_subnet.id

  private_service_connection {
    name                           = "pg-connection-${var.environment}"
    private_connection_resource_id = azurerm_postgresql_server.pgdb.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }
}

resource "azurerm_service_plan" "app_plan" {
  name                = "asp-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku_name
}

resource "azurerm_linux_web_app" "web_app" {
  name                = "webapp-${var.environment}-${random_id.suffix.hex}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.app_plan.location
  service_plan_id     = azurerm_service_plan.app_plan.id

  site_config {
    application_stack {
      python_version = var.python_version
    }
  }

  app_settings = {
    DATABASE_URL = "postgresql://${var.postgresql_admin_username}:${var.postgresql_admin_password}@${azurerm_postgresql_server.pgdb.fqdn}:5432/postgres"
  }
}
