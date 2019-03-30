output "worker_public_ips" {
  value = "${azurerm_public_ip.worker.*.ip_address}"
}

output "master_public_ip" {
  value = "${azurerm_public_ip.master.*.ip_address}"
}

output "worker_private_ips" {
  value = "${azurerm_network_interface.worker.*.private_ip_address}"
}

output "master_private_ip" {
  value = "${azurerm_network_interface.master.0.private_ip_address}"
}
