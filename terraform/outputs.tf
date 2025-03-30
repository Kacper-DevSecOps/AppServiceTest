output "webapp_url" {
  value = azurerm_linux_web_app.web_app.default_hostname
}

output "postgres_fqdn" {
  value = azurerm_postgresql_server.pgdb.fqdn
}
