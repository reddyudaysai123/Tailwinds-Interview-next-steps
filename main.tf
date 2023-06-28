resource "azurerm_resource_group" "my_resg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "my_vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.my_resg.location
  resource_group_name = azurerm_resource_group.my_resg.name
    depends_on = [
    azurerm_resource_group.my_resg
  ]
}

resource "azurerm_subnet" "my_subnet1" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.my_resg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = [var.subnet1]
}

resource "azurerm_subnet" "my_subnet2" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.my_resg.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = [var.subnet2pv]
    depends_on = [
    azurerm_resource_group.my_resg,
    azurerm_virtual_network.my_vnet
  ]
}
resource "azurerm_network_security_group" "my_nsg" {
  name                = "nsg"
  location            = azurerm_resource_group.my_resg.location
  resource_group_name = azurerm_resource_group.my_resg.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "my_nsgsubnet" {
  subnet_id                 = azurerm_subnet.my_subnet1.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "my-aks-cluster"
  location            = azurerm_resource_group.my_resg.location
  resource_group_name = azurerm_resource_group.my_resg.name
  dns_prefix          = "my-aks-cluster"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
    vnet_subnet_id      = azurerm_subnet.my_subnet1.id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
