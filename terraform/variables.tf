variable "location" {
  description = "Region Azure"
  type = string
  default = "polandcentral"
}

variable "resource_group_name" {
    description = "Nazwa grupy zasobów"
    type = string
    default = "message-app-rg"   
}

variable "vm_name" {
    description = "Nazwa VM"
    type = string
    default = "message-app-vm"
}

variable "admin_username" {
  description = "Nazwa admina VM"
  type = string
  default = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Ścieżka publicznego klucza ssh"
  type = string
  default = "~/.ssh/azure_message_app.pub"
}
