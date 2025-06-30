# Criação do Resource Group onde os recursos serão agrupados
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}
 
# Criação da rede virtual (VNet) com um espaço de endereçamento
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
 
# Sub-rede dentro da VNet
resource "azurerm_subnet" "example" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}
 
# Criação de um IP público dinâmico para acesso remoto (RDP)
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic" # IP é alocado automaticamente
  sku                 = "Basic"
}
 
# Grupo de segurança de rede (NSG) com regra para liberar acesso RDP (porta 3389)
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
 
  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"    # Permite de qualquer porta de origem
    destination_port_range     = "3389" # Porta RDP
    source_address_prefix      = "*"    # Permite de qualquer IP
    destination_address_prefix = "*"    # Aplica a qualquer destino dentro da rede
  }
}
 
# Associação do NSG à sub-rede, protegendo todos os recursos dentro dela
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}
 
# Interface de rede (NIC) que conecta a VM à sub-rede e ao IP público
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
 
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id # Conecta IP público à NIC
  }
}
 
# Criação da máquina virtual Windows Server
resource "azurerm_windows_virtual_machine" "example" {
  name                = "example-machine"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_F2" # Tamanho da VM
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!" # Senha segura conforme exigência do Azure
 
  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
 
  # Imagem da VM (Windows Server 2016 Datacenter)
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
