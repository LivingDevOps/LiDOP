output "worker_public_ips" {
  value = "${vra7_deployment.worker.*.resource_configuration.Machine.ip_address}"
}
output "master_public_ip" {
  value = "${vra7_deployment.master.*.resource_configuration.Machine.ip_address}"
}
output "worker_private_ips" {
  value = "${vra7_deployment.worker.*.resource_configuration.Machine.ip_address}"
}
output "master_private_ip" {
  value = "${vra7_deployment.master.*.resource_configuration.Machine.ip_address}"
}

