resource "azurerm_virtual_network" "main" {
  count               = "${var.enabled}"
  name                = "${var.lidop_name}-network"
  address_space       = ["172.10.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "internal" {
  count                = "${var.enabled}"
  name                 = "${var.lidop_name}-internal"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "172.10.10.0/24"
}

resource "azurerm_network_interface" "master" {
  count               = "${var.enabled}"
  name                = "${var.lidop_name}-master-nic"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"  

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.10.10.10"
    public_ip_address_id          = "${azurerm_public_ip.master.id}"
  }
}

resource "azurerm_public_ip" "master" {
  count               = "${var.enabled}"
  name                    = "${var.lidop_name}-master-pip"
  location                = "${azurerm_resource_group.main.location}"
  resource_group_name     = "${azurerm_resource_group.main.name}"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "worker" {
  count               = "${var.enabled * var.workers}"
  name                = "${var.lidop_name}-worker-nic-${count.index}"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.nsg.id}"  
  
  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.10.10.1${count.index}"
    public_ip_address_id          = "${azurerm_public_ip.worker.id}"
  }
}

resource "azurerm_public_ip" "worker" {
  // count                 = "${var.enabled * var.workers}"
  count                 = "${var.workers == "0" ? 1 : var.enabled * var.workers}" // hack must be minimum one for outputs
  name                    = "${var.lidop_name}-pip-worker"
  location                = "${azurerm_resource_group.main.location}"
  resource_group_name     = "${azurerm_resource_group.main.name}"
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_security_group" "nsg" {
  count               = "${var.enabled}"
  name                = "${var.lidop_name}-security-group"  
  location            = "${var.azure_region}"
  resource_group_name = "${azurerm_resource_group.main.name}"  
  
  security_rule {
    name                       = "HTTPS"  
    priority                   = 1001
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "443"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  

  security_rule {
    name                       = "ssh"  
    priority                   = 1000  
    direction                  = "Inbound"  
    access                     = "Allow"  
    protocol                   = "Tcp"  
    source_port_range          = "*"  
    destination_port_range     = "22"  
    source_address_prefix      = "*"  
    destination_address_prefix = "*"  
  }  

  tags {  
    environment = "${var.lidop_name}"  
  }  
}  