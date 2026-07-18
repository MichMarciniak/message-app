output "public_ip_address" {
    description = "Publiczny adres IP VM"
    value = azurerm_public_ip.main.ip_address
}