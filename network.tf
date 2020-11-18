# Create VNET

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.AzureRG.location
  resource_group_name = azurerm_resource_group.AzureRG.name
  address_space       = ["10.1.0.0/16"]
}

#Create Virtual machine subnet
resource "azurerm_subnet" "VMnetwork" {
  name                 = "VMSubnet"
  resource_group_name  = azurerm_resource_group.AzureRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

# Crate Gateway Subnet
resource "azurerm_subnet" "GWsubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.AzureRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.1.1.0/24"]
}

# Create public IP for virtual network gateway
resource "azurerm_public_ip" "VNG-pip" {
  name                = "${var.prefix}-VNG-pip"
  location            = azurerm_resource_group.AzureRG.location
  resource_group_name = azurerm_resource_group.AzureRG.name
  allocation_method   = "Dynamic"
}

# Create virtual network gateway
resource "azurerm_virtual_network_gateway" "vgw" {
  name                = "${var.prefix}-vnetgw"
  location            = azurerm_resource_group.AzureRG.location
  resource_group_name = azurerm_resource_group.AzureRG.name

  #Vpn or ExpressRoute
  type     = "ExpressRoute"
  sku      = "Standard"
  #RouteBased or PolicyBased
  #vpn_type = "RouteBased"

  ip_configuration {
     name                          = "vnetGatewayConfig"
     public_ip_address_id          = azurerm_public_ip.VNG-pip.id
     private_ip_address_allocation = "Dynamic"
     subnet_id                     = azurerm_subnet.GWsubnet.id
  }

}

# Create ExpressRT
resource "azurerm_express_route_circuit" "ExpressRT" {
  name                  = "${var.prefix}-expressRoute"
  resource_group_name   = azurerm_resource_group.AzureRG.name
  location              = azurerm_resource_group.AzureRG.location
  service_provider_name = var.fastconenct
  peering_location      = var.fastconenct-location.Tokyo
  bandwidth_in_mbps     = 50

  # you can use ExpressRT local https://docs.microsoft.com/en-us/azure/expressroute/expressroute-faqs#:~:text=What%20is%20ExpressRoute%20Local%3F,or%20near%20the%20same%20metro.
  sku {
    tier   = "Standard"
    family = "MeteredData"
  }
}

# association with Express Route
resource "azurerm_virtual_network_gateway_connection" "AzureOCI-Connection" {
  name                = "${var.prefix}-connection"
  location            = azurerm_resource_group.AzureRG.location
  resource_group_name = azurerm_resource_group.AzureRG.name

  type                       = "ExpressRoute"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vgw.id
  express_route_circuit_id   = azurerm_express_route_circuit.ExpressRT.id

  #shared_key = "optional"
}

# Create Network security group to allow traffics from Oracle Cloud
resource "azurerm_network_security_group" "AzureOCI-NSG" {
  name                = "${var.prefix}-NSG"
  location            = azurerm_resource_group.AzureRG.location
  resource_group_name = azurerm_resource_group.AzureRG.name

  security_rule {
    name                       = "AllowOCItraffics"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "192.168.0.0/16"
    destination_address_prefix = "10.1.0.0/16"
  }

  tags = {
    environment = "Production"
  }
}

# Create Route Table to Oracle Cloud
resource "azurerm_route_table" "AzureOCI-RT" {
  name                          = "${var.prefix}-RT"
  location                      = azurerm_resource_group.AzureRG.location
  resource_group_name           = azurerm_resource_group.AzureRG.name
  disable_bgp_route_propagation = false

  route {
    name           = "FromAzureToOCI"
    address_prefix = "192.168.0.0/16"
    next_hop_type  = "VirtualNetworkGateway"
  }
}

# Associate VM subnet with AzureOCI-RT
resource "azurerm_subnet_route_table_association" "subnet-RT" {
  subnet_id      = azurerm_subnet.VMnetwork.id
  route_table_id = azurerm_route_table.AzureOCI-RT.id
}