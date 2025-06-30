variable "resource_group_name" {
  description = "Nome do Resource Group"
  type        = string
}
 
variable "location" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "West Europe"
}
 
variable "vm_name" {
  description = "Nome da máquina virtual"
  type        = string
  default     = "example-machine"
}
 
variable "admin_username" {
  description = "Usuário administrador da VM"
  type        = string
}
 
variable "admin_password" {
  description = "Senha do administrador da VM"
  type        = string
  sensitive   = true
}
