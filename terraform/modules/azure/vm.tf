resource "azurerm_virtual_machine" "master" {
  count                            = "${var.enabled}"
  name                             = "${var.lidop_name}-lidop-master"
  location                         = "${azurerm_resource_group.main.location}"
  resource_group_name              = "${azurerm_resource_group.main.name}"
  network_interface_ids            = ["${azurerm_network_interface.master.id}"]
  vm_size                          = "Standard_B4ms"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.lidop_name}-lidop-master-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "master"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true
     ssh_keys = [{
        path     = "/home/ubuntu/.ssh/authorized_keys"
        key_data = "${file("${path.root}/temp_key.pub")}"
      }]
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine" "worker" {
  count                 = "${var.enabled * var.workers}"
  name                  = "${var.lidop_name}-lidop-worker-${count.index}"
  depends_on            = ["azurerm_virtual_machine.master"]
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = ["${element(azurerm_network_interface.worker.*.id, count.index)}"]
  vm_size               = "Standard_B2ms"
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.lidop_name}-lidop-worker-${count.index}-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "worker${count.index}"
    admin_username = "ubuntu"
  }

  os_profile_linux_config {
    disable_password_authentication = true
     ssh_keys = [{
        path     = "/home/ubuntu/.ssh/authorized_keys"
        key_data = "${file("${path.root}/temp_key.pub")}"
      }]
  }

  tags = {
    environment = "staging"
  }
}
