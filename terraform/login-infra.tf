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