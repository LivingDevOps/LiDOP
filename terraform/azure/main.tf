provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.22.0"

  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

resource "azurerm_resource_group" "main" {
  count    = "${var.enabled}"
  name     = "${var.lidop_name}-${terraform.workspace}-lidop-resources"
  location = "${var.azure_region}"
}

module "private_key" {
  source = "./../modules/private_key"
}

module "provisioner" {
  source             = "./../modules/provisioner"
  user_name          = "${var.user_name}"
  password           = "${var.password}"
  workers            = "${var.workers}"
  private_key        = "${module.private_key.private_key}"
  worker_public_ips  = "${azurerm_public_ip.worker.*.ip_address}"
  master_public_ip   = "${azurerm_public_ip.master.*.ip_address}"
  worker_private_ips = "${azurerm_network_interface.worker.*.private_ip_address}"
  master_private_ip  = "${azurerm_network_interface.master.*.private_ip_address}"
}
