# Azure Resource Group
resource "azurerm_resource_group" "login-rg" {
  name     = "login-rg"
  location = "eastus"
}

# VNET
resource "azurerm_virtual_network" "login-vnet" {
  name                = "login-vnet"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
  address_space       = ["10.0.0.0/16"]
}

# Web Subnet

resource "azurerm_subnet" "login-web-subnet" {
  name                 = "login-web-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# API Subnet
resource "azurerm_subnet" "login-api-subnet" {
  name                 = "login-api-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# DB Subnet

resource "azurerm_subnet" "login-db-subnet" {
  name                 = "login-db-subnet"
  resource_group_name  = azurerm_resource_group.login-rg.name
  virtual_network_name = azurerm_virtual_network.login-vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# web-pub-ip
resource "azurerm_public_ip" "login-web-pip" {
  name                = "login-web-pip"
  resource_group_name = azurerm_resource_group.login-rg.name
    location            = azurerm_resource_group.login-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

# API-pub-ip
resource "azurerm_public_ip" "login-API-pip"  {
  name                = "login-API-pip"
  resource_group_name = azurerm_resource_group.login-rg.name
    location            = azurerm_resource_group.login-rg.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

# Web-NSG
resource "azurerm_network_security_group" "login-web-nsg" {
  name                = "login-web-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

# web-nsg-ssh
resource "azurerm_network_security_rule" "login-web-nsg-ssh" {
    name                       = "login-web-nsg-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
   resource_group_name = azurerm_resource_group.login-rg.name
   network_security_group_name = azurerm_network_security_group.login-web-nsg.name
  }

# web-nsg-http
resource "azurerm_network_security_rule" "login-web-nsg-http" {
    name                       = "login-web-nsg-http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
   resource_group_name = azurerm_resource_group.login-rg.name
   network_security_group_name = azurerm_network_security_group.login-web-nsg.name
  }

# API-NSG
resource "azurerm_network_security_group" "login-API-nsg" {
  name                = "login-API-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

# API-nsg-ssh
resource "azurerm_network_security_rule" "login-API-nsg-ssh" {
    name                       = "login-API-nsg-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
   resource_group_name = azurerm_resource_group.login-rg.name
   network_security_group_name = azurerm_network_security_group.login-API-nsg.name
  }

  # API-nsg-http
   resource "azurerm_network_security_rule" "login-API-nsg-http" {
    name                       = "login-API-nsg-http"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
   resource_group_name = azurerm_resource_group.login-rg.name
   network_security_group_name = azurerm_network_security_group.login-API-nsg.name
  }

  # DB-NSG
resource "azurerm_network_security_group" "login-db-nsg" {
  name                = "login-db-nsg"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name
}

# API-nsg-ssh
resource "azurerm_network_security_rule" "login-db-nsg-ssh" {
    name                       = "login-db-nsg-ssh"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
   resource_group_name = azurerm_resource_group.login-rg.name
   network_security_group_name = azurerm_network_security_group.login-db-nsg.name
  }

# API-nsg-http
resource "azurerm_network_security_rule" "login-db-nsg-http" {
    name                       = "login-db-nsg-http"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
   resource_group_name = azurerm_resource_group.login-rg.name
   network_security_group_name = azurerm_network_security_group.login-db-nsg.name
  }

# Web NIC
resource "azurerm_network_interface" "login-web-nic" {
  name                = "login-web-nic"
  location            = azurerm_resource_group.login-rg.location
  resource_group_name = azurerm_resource_group.login-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.login-web-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.login-web-pip.id
  }
}

# Web NIC - NSG ASC
resource "azurerm_network_interface_security_group_association" "login-web-nic-asc" {
  network_interface_id      = azurerm_network_interface.login-web-nic.id
  network_security_group_id = azurerm_network_security_group.login-web-nsg.id
}