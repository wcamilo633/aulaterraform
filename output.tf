output "rdp_username" {
  description = "Usuário administrador da VM"
  value       = var.admin_username
}
 
output "rdp_password" {
  description = "Senha do administrador da VM"
  value       = var.admin_password
  sensitive   = true
}
 
output "public_ip_address" {
  description = "IP público da VM para acesso RDP"
  value       = azurerm_public_ip.example.ip_address
}
